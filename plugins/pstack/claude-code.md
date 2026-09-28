# Running pstack in Claude Code

pstack is written for Cursor. In Claude Code, translate its tools and models as follows.

| Cursor | Claude Code |
|---|---|
| `Task` | `Agent` tool; `run_in_background: true` as written |
| `subagent_type: "poteto-agent"` | `subagent_type: "pstack:poteto-agent"` |
| `subagent_type: "Comment Sicko"` | `subagent_type: "pstack:comment-sicko"` |
| readonly Task | `Explore` agent |
| `AskQuestion` | `AskUserQuestion` |
| hardest tasks, judgment and prose (`claude-opus-*`) | `model: opus` |
| code roles (`grok-*`, `gpt-*`) | `model: sonnet` |
| trivial mechanical edits | `model: haiku` |
| `/setup-pstack` rule | not available; use the defaults above |
| `cursor-team-kit` skills (`deslop`, `control-ui`, `control-cli`), Cursor `create-skill` | not installed; skip the step and say so in the reply |
