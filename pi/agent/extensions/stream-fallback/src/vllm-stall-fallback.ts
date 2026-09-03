import crypto from "node:crypto";

const STALL_MS = 15_000;

function announce(msg: string) {
  process.stderr.write(`\n[stream-fallback] ${msg}\n`);
}

function hashMessages(messages: unknown): string {
  return crypto.createHash("sha1").update(JSON.stringify(messages ?? [])).digest("hex");
}

function completionToChunk(completion: any) {
  return {
    id: completion.id,
    object: "chat.completion.chunk",
    created: completion.created,
    model: completion.model,
    choices: (completion.choices ?? []).map((c: any) => ({
      index: c.index,
      delta: {
        role: c.message?.role,
        content: c.message?.content ?? null,
        tool_calls: c.message?.tool_calls?.map((tc: any, i: number) => ({
          index: i,
          id: tc.id,
          type: tc.type,
          function: { name: tc.function?.name, arguments: tc.function?.arguments },
        })),
      },
      finish_reason: c.finish_reason,
      logprobs: c.logprobs ?? null,
    })),
    usage: completion.usage,
  };
}

function sseStreamFromCompletion(completion: any): ReadableStream<Uint8Array> {
  const encoder = new TextEncoder();
  const chunk = completionToChunk(completion);
  return new ReadableStream({
    start(controller) {
      controller.enqueue(encoder.encode(`data: ${JSON.stringify(chunk)}\n\n`));
      controller.enqueue(encoder.encode(`data: [DONE]\n\n`));
      controller.close();
    },
  });
}

// Conversations that already stalled once. Pi's own auto-retry strips the
// failed assistant message before retrying, so the retry's `messages` array
// matches the original attempt's — this lets us recognize it and skip
// straight to non-streaming instead of risking the same stall again.
const forceNonStream = new Set<string>();

async function doNonStreamFallback(
  origFetch: typeof fetch,
  url: Parameters<typeof fetch>[0],
  init: RequestInit,
  body: any,
): Promise<Response> {
  body.stream = false;
  delete body.stream_options;
  const res = await origFetch(url, { ...init, body: JSON.stringify(body) });

  if (!res.ok) return res;

  const contentType = res.headers.get("content-type") ?? "";
  if (!contentType.includes("application/json")) return res;

  let completion: any;
  try {
    completion = await res.json();
  } catch {
    return res;
  }

  const stream = sseStreamFromCompletion(completion);
  const headers = new Headers(res.headers);
  headers.set("content-type", "text/event-stream");
  headers.delete("content-length");
  return new Response(stream, { status: res.status, statusText: res.statusText, headers });
}

// Live pass-through with a stall watchdog. Forwards bytes to the caller as
// they arrive. If generation has started and then nothing arrives for
// STALL_MS, cancels the upstream reader and errors the outgoing stream with
// a message pi's retry classifier recognizes as a transient network failure
// (pi-ai/utils/retry.js RETRYABLE_PROVIDER_ERROR_PATTERN), handing off to
// pi's existing turn-level auto-retry instead of reimplementing rollback here.
function withLiveStallWatchdog(res: Response, msgHash: string): Response {
  const upstream = res.body!.getReader();
  let sawFirstChunk = false;
  let lastChunkAt = Date.now();
  let stalled = false;
  let timer: ReturnType<typeof setInterval> | null = null;

  const stream = new ReadableStream<Uint8Array>({
    start(controller) {
      timer = setInterval(() => {
        if (!sawFirstChunk || stalled) return;
        const gap = Date.now() - lastChunkAt;
        if (gap > STALL_MS) {
          stalled = true;
          forceNonStream.add(msgHash);
          announce(
            `streaming tool-call parser stalled (no data for ${Math.round(gap / 1000)}s) — ` +
              `known vLLM bug (PR #53739). Failing this attempt so pi retries; the retry will use non-streaming.`,
          );
          if (timer) clearInterval(timer);
          upstream.cancel().catch(() => {});
          controller.error(
            new Error(
              `stream-fallback: connection lost — vLLM streaming tool-call parser stalled for ${Math.round(gap / 1000)}s (known bug, PR #53739)`,
            ),
          );
        }
      }, 1000);
      pump();

      async function pump() {
        try {
          while (true) {
            const { done, value } = await upstream.read();
            if (stalled) return;
            if (done) {
              if (timer) clearInterval(timer);
              controller.close();
              return;
            }
            sawFirstChunk = true;
            lastChunkAt = Date.now();
            controller.enqueue(value);
          }
        } catch (err) {
          if (timer) clearInterval(timer);
          if (!stalled) controller.error(err);
        }
      }
    },
    cancel(reason) {
      if (timer) clearInterval(timer);
      upstream.cancel(reason).catch(() => {});
    },
  });

  const headers = new Headers(res.headers);
  return new Response(stream, { status: res.status, statusText: res.statusText, headers });
}

export function installVllmStallFallback() {
  const origFetch = global.fetch;
  global.fetch = (async (...args: Parameters<typeof fetch>) => {
    const [url, init] = args;
    const urlStr = typeof url === "string" ? url : url.toString();
    const isChatCompletions = urlStr.includes("/chat/completions");

    if (!isChatCompletions || typeof init?.body !== "string") {
      return origFetch(...args);
    }

    let body: any;
    try {
      body = JSON.parse(init.body);
    } catch {
      return origFetch(...args);
    }

    if (body.stream !== true) {
      return origFetch(url, init);
    }

    const msgHash = hashMessages(body.messages);

    if (forceNonStream.has(msgHash)) {
      return doNonStreamFallback(origFetch, url, init, body);
    }

    const res = await origFetch(url, init);
    if (!res.ok || !res.body) {
      return res;
    }

    return withLiveStallWatchdog(res, msgHash);
  }) as typeof fetch;
}
