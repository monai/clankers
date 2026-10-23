---
name: how
description: "Use for 'how does X work', code walkthroughs before changing something, and placement / ownership / layering questions ('where should this live', 'which package owns this', 'is this the right layer'). Explains subsystem architecture, runtime flow, onboarding mental models. Use why for motivation."
disable-model-invocation: true
---

# How

Explore the codebase to answer "how does X work?" questions. Produce architectural explanations at the level of a senior engineer onboarding onto a subsystem, enough to build a working mental model, not so much that it reads like annotated source code.

Explorers are Agent subagents with `subagent_type: how-explorer`, and every explainer is an Agent subagent with `subagent_type: how-explainer`. Do not pass `model`.

Build each subagent's prompt from its template below. Fill in the placeholders.

Explorer prompt template:

```markdown
## Question

> {QUESTION}

## Your Exploration Angle

{EXPLORATION_ANGLE}
```

Explainer prompt template:

```markdown
## Original Question

> {QUESTION}

## Explorer Findings

{EXPLORER_FINDINGS_ALL}
```

## 1. Assess complexity

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

- **Simple** (a single module, a small utility, a narrow question such as "how does function X work"): no explorers. Spawn one explainer that explores and explains in one pass, built from the explainer prompt template without the Explorer Findings section. Go to step 4.
- **Complex** (a subsystem spanning multiple files or services, a cross-cutting feature, a full architectural overview): go to step 2.

When in doubt, take the simple path.

## 2. Explore (complex only)

Decompose the question into 2 to 4 angles, each a distinct slice of the subsystem. Spawn all explorers in a single message, each with the explorer prompt template and its angle filled in.

## 3. Synthesize (complex only)

Once all explorers have returned, spawn one explainer with the explainer prompt template and every explorer's findings filled in.

## 4. Present

Present the explainer's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.

## Output format

The explanation uses the sections defined in `.claude/agents/how-explainer.md`, dropping any that do not apply: Overview, Key Concepts, How It Works, Where Things Live, Gotchas.
