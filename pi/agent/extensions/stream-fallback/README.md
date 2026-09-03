# stream-fallback

## `src/keepalive-patch.ts`

Disables `SO_KEEPALIVE` on all sockets, working around Docker Desktop
vpnkit NAT dropping keepalive-probed connections.

Also requires `"VpnKitMaxPortIdleTime": 0` in
`~/Library/Group Containers/group.com.docker/settings-store.json`.

## `src/vllm-stall-fallback.ts`

Works around a vLLM `qwen3_xml` streaming tool-call parser freeze
([vllm-project/vllm#53739](https://github.com/vllm-project/vllm/pull/53739)).

Watches inter-chunk gaps; on stall, errors the stream with a
retry-classifier-matched message to trigger pi's auto-retry, then serves
that retry as a non-streaming request.

## Timeouts

The non-streaming fallback sends no bytes until the full completion is
ready, so it must outlast both:

- `httpIdleTimeoutMs` — idle timeout, resets per byte received.
- `retry.provider.timeoutMs` — total request timeout, never resets.

Set both to: max output tokens ÷ slowest observed decode speed
(tokens/s), plus margin.
