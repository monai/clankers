# Plugins

Skills and agents for Claude, Codex, and Pi.

| Plugin | Version | Purpose |
| --- | --- | --- |
| essentials | Local | Our skills and agents |
| mattpocock-skills | 1.3.1 | Engineering workflows |
| pstack | 0.15.5 | Planning, review, and agent workflows |

## Use

Add the marketplace:

```sh
claude plugin marketplace add monai/clankers
codex plugin marketplace add monai/clankers
```

Install plugins through Claude's `/plugin` or Codex's `/plugins`. Start a new Codex session after installation.

## Maintain

Sources: `essentials/src/` for ours; `upstream/` for pinned Git submodules. Essentials skills default to explicit invocation. Set `disable-model-invocation: false` to allow automatic invocation.

From the repo root:

```sh
make -C plugins         # Build
make -C plugins update  # Update upstreams and build
make install            # Build and install local settings, agents, and Pi skills
```

Commit submodule pins and built `claude/` and `codex/` folders together. Update the versions above. Pi builds stay ignored in `plugins/dist/pi/`.
