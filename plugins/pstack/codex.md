# Running pstack in Codex

pstack is written for Cursor. In Codex, translate its tools and models as follows.

| Cursor | Codex |
|---|---|
| `Task` | `spawn_agent` with `fork_turns: "none"`; collect results with `wait_agent` |
| `run_in_background: true` | spawned agents already run alongside you; call `wait_agent` when you need the result |
| `subagent_type: "poteto-agent"` | `agent_type: "poteto-agent"` |
| `subagent_type: "Comment Sicko"` | `agent_type: "comment-sicko"` |
| readonly Task | `agent_type: "explorer"` |
| `AskQuestion` | ask the user in your reply and stop |
| per-role models (`claude-opus-*`, `grok-*`, `gpt-*`) | omit `model` and `reasoning_effort`; the agent inherits yours |
| `/skill-name` or "the **name** skill" | `$pstack:name` |
| `/setup-pstack` rule | not available; use the defaults above |
| Cursor `create-skill` | `$skill-creator` |
| `cursor-team-kit` skills (`deslop`, `control-ui`, `control-cli`) | not installed; skip the step and say so in the reply |
