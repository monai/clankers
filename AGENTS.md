## Writing

Keep each Markdown paragraph on one line.

Use simple English. No fluff.

## Agent skills

### Issue tracker

Issues and specs are local markdown files under `.scratch/<feature>/` in this repo. See `docs/agents/issue-tracker.md`.

### Triage labels

The five default triage roles; label strings equal the role names. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: root `CONTEXT.md` + `docs/adr/` (neither exists yet; created lazily). See `docs/agents/domain.md`.

## Agent Plugins

Agent Plugins specification: https://agent-plugins.org/llms.txt
Claude plugins: https://code.claude.com/docs/en/plugins/create

When updating upstream submodule revisions, update both plugin versions in `plugins/README.md` from the manifests at the pinned revisions.
