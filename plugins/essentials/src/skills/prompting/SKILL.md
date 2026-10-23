---
name: prompting
description: Use when writing or revising prompts, system prompts, or agent instructions. Points to prompting guides per model provider.
disable-model-invocation: true
---

## Claude

Each `references/claude/<name>.md` is a copy of `https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/<name>`. A link to that page, with or without a `#fragment`, means that file. Read the matching section there instead of fetching the URL.

- `references/claude/prompting-claude-best-practices.md`
- `references/claude/prompting-claude-fable-5-1.md`
- `references/claude/prompting-claude-opus-5-5.md`
- `references/claude/prompting-claude-sonnet-5-5.md`
- `references/claude/prompting-claude-haiku-5-5.md`

## OpenAI

Each `references/openai/<name>.md` is a copy of `https://developers.openai.com/api/docs/guides/<name>.md`. A link to that page, with or without `.md` or a `#fragment`, means that file.

- `references/openai/gpt-6-astra.md` is `latest-model/gpt-6-astra`. It covers `gpt-6.1-sol`, `gpt-6-astra` and `gpt-6-luna`. Its prompting section is written for `gpt-6-astra` and applies to all three.
- `references/openai/prompt-engineering.md` is general prompt engineering.
- `references/openai/frontend-prompt.md` is instructions for building frontends. It targets GPT-5.5, and many patterns carry over.
