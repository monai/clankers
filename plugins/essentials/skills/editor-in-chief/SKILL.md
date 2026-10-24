---
name: editor-in-chief
description: Edits technical text, such as docs, specs, READMEs, prompts, and skills, into terse, explicit, simple English.
disable-model-invocation: true
---

# Editor in chief

The **reader** is the person or model who will use the text later. The reader has not seen this conversation, the feedback, or earlier versions of the text. Write only what the reader needs to act.

## Process

1. Read the whole target file. Done when you can name its reader and its purpose.
2. Check every line against the keep test and the rules below. Done when each line is kept, cut, or rewritten.
3. Search the file for every term you replaced. Done when no old term remains.
4. Edit the file only when the user asks for changes. Otherwise, show the proposed diff. Commit only when asked.

## Keep test

Keep a line only if both hold:

- It tells the reader something they would not do or know without it.
- It repeats nothing the text says elsewhere.

Make the smallest change. Cut before you reword. Change a word before you add a sentence. Edit the place where the meaning already is.

## Wording

- Use simple English: common words, short sentences, one idea each, literal meaning ("are in", not "live in").
- Be concrete and explicit. Name the exact file, block, or step. Replace vague words such as "label", "part", or "owns" with the thing they mean.
- Keep precise technical terms such as invariants, side effects, callers, and outputs.
- Say what to do. Write "do not" only when the reader would otherwise do it.
- Give a reason only when it changes what the reader does.

## Cuts

- Rules that guard against one past mistake. Write the target behavior instead.
- Exact output strings when a plain instruction works. Write "say so in one line", not a quoted sentence.
- Fillers for empty parts, such as "None", dashes, or empty tables. Tell the reader to leave out parts with no content.

## Terms

- Define each term once, in bold, where it first appears.
- Use one term for each idea in the whole text. Do not use one word for two ideas.

## Layout

- Order sections as definitions, steps, output format, then rules.
- Write each Markdown paragraph on one line.
- Give an output format as a template with `<placeholders>`, then one filled example. Show changes as diffs.
- Keep worked examples whole, with their code comments.
- In a skill, write the frontmatter `description` as one line in third person that says what the skill does.

## Claims

When the user or the record asserts a fact, check it against the record before acting. Where the user is wrong, say so with the evidence. Where right, say so plainly and continue.

## Reply to the user

Lead with the diff or a table of change and rule applied. Write at most one line of prose after it.
