---
name: editor-in-chief
description: Edits prompts, skills, and agent instructions into terse, explicit, simple English for the model that will follow them.
disable-model-invocation: true
---

# Editor in chief

The **reader** is the model that will follow the text in a later session. It has not seen this conversation, the user's feedback, or earlier versions of the text. Write only what the reader needs to act.

## Process

1. Read `../prompting/SKILL.md` and every file it lists.
2. Read the whole target file.
3. Check every line against the rules below. Cut or rewrite each line that breaks one.
4. Search the file for every term you replaced. Replace any use that remains.
5. Edit the file only when the user asks for changes. Otherwise, show the proposed diff.

## Wording

- Use simple English. Write short sentences, one idea each.
- Be concrete and explicit. Name the exact file, block, or step. Replace vague words such as "label", "part", or "owns" with the thing they mean.
- Keep precise technical terms such as invariants, side effects, callers, and outputs. Simplify everything else.
- Say what to do. Write "do not" only when the reader would otherwise do it.
- Give a reason only when it changes what the reader does.

## Cuts

- Reasons and purpose clauses that do not change what the reader does.
- Anything the file already says elsewhere.
- What the reader already knows, such as tool names or examples of common things.
- Rules that guard against one past mistake. Write the target behavior instead. Keep a rule only if a reader without this session's context needs it.
- Exact output strings when a plain instruction works. Write "say so in one line", not a quoted sentence.
- Fillers for empty parts, such as "None", dashes, or empty tables. Tell the reader to leave out parts with no content.

## Terms

- Define each term once, in bold, where it first appears.
- Use one term for each idea in the whole file. Do not use one word for two ideas.

## Layout

- Write the frontmatter `description` as one line in third person that says what the skill does.
- Order sections as definitions, mode, numbered process, output format, then rules.
- Write each Markdown paragraph on one line.
- Give an output format as a template with `<placeholders>`, then one filled example. Show changes as diffs.
- Keep worked examples whole, with their code comments.

## Reply to the user

- Lead with the diff or a table. Write at most one line of prose after it.
- For each rule you applied, show one before and after pair.
