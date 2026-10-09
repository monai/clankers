USER_CLAUDE_DIR := $(HOME)/.claude

USER_CODEX_DIR := $(or $(CODEX_HOME),$(HOME)/.codex)
CODEX_AGENT_DIRS = $(wildcard plugins/*/codex/agents)

USER_PI_DIR := $(or $(PI_CODING_AGENT_DIR),$(HOME)/.pi/agent)
PI_PLUGINS = $(patsubst plugins/dist/pi/%/skills,%,$(wildcard plugins/dist/pi/*/skills))

.PHONY: install plugins

install: plugins
	mkdir -p $(USER_CLAUDE_DIR)
	cp -a claude/CLAUDE.md $(USER_CLAUDE_DIR)/CLAUDE.md
	cp -a claude/settings.json $(USER_CLAUDE_DIR)/settings.json

	rm -rf $(USER_CODEX_DIR)/agents
	mkdir -p $(USER_CODEX_DIR)/agents
	cp -a claude/CLAUDE.md $(USER_CODEX_DIR)/AGENTS.md
	$(foreach dir,$(CODEX_AGENT_DIRS),tar -C $(dir) -cf - . | tar -C $(USER_CODEX_DIR)/agents -xf -;)
	cp -a codex/config.toml $(USER_CODEX_DIR)/config.toml

	rm -rf $(USER_PI_DIR)/skills
	mkdir -p $(USER_PI_DIR)/skills
	cp -a claude/CLAUDE.md $(USER_PI_DIR)/AGENTS.md
	$(foreach p,$(PI_PLUGINS),mkdir -p $(USER_PI_DIR)/skills/$(p) && tar -C plugins/dist/pi/$(p)/skills -cf - . | tar -C $(USER_PI_DIR)/skills/$(p) -xf -;)

plugins:
	$(MAKE) -C plugins
