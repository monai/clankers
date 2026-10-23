# Plugins

Skills and agents for Claude, Codex, and Pi.

| Plugin | Version | Purpose |
| --- | --- | --- |
| essentials | Local | Our skills and agents |
| mattpocock-skills | 1.3.1 | Engineering workflows |

## Use

Add the marketplace:

```sh
claude plugin marketplace add monai/clankers
codex plugin marketplace add monai/clankers
```

Install plugins through Claude's `/plugin` or Codex's `/plugins`. Start a new Codex session after installation.

## Maintain

`essentials/` is one plugin for Claude and Codex. Edit it in place; there is no build. Each skill has `disable-model-invocation: true` in `SKILL.md` for Claude and `agents/openai.yaml` for Codex. Keep both in sync. Set the frontmatter to `false` and delete the YAML to allow automatic invocation.

`mattpocock-skills/` is built from the pinned submodule in `upstream/`.

From the repo root:

```sh
make -C plugins         # Build mattpocock-skills
make -C plugins update  # Update upstreams and build
make install            # Build and install local settings, agents, and Pi skills
```

Commit submodule pins and built `claude/` and `codex/` folders of `mattpocock-skills` together. Update the versions above. Pi builds stay ignored in `plugins/dist/pi/`.
