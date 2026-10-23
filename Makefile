USER_CLAUDE_DIR := $(HOME)/.claude

USER_CODEX_DIR := $(or $(CODEX_HOME),$(HOME)/.codex)
ESSENTIALS_AGENTS := $(wildcard plugins/essentials/agents/*.md)

USER_PI_DIR := $(or $(PI_CODING_AGENT_DIR),$(HOME)/.pi/agent)

.PHONY: install

install:
	mkdir -p $(USER_CLAUDE_DIR)
	cp -a claude/CLAUDE.md $(USER_CLAUDE_DIR)/CLAUDE.md
	cp -a claude/settings.json $(USER_CLAUDE_DIR)/settings.json

	rm -rf $(USER_CODEX_DIR)/agents
	mkdir -p $(USER_CODEX_DIR)/agents
	cp -a claude/CLAUDE.md $(USER_CODEX_DIR)/AGENTS.md
	$(foreach f,$(ESSENTIALS_AGENTS),awk -v name=$(basename $(notdir $(f))) -f plugins/scripts/agent-to-toml.awk $(f) > $(USER_CODEX_DIR)/agents/$(basename $(notdir $(f))).toml;)
	cp -a codex/config.toml $(USER_CODEX_DIR)/config.toml

	rm -rf $(USER_PI_DIR)/skills
	mkdir -p $(USER_PI_DIR)/skills
	cp -a claude/CLAUDE.md $(USER_PI_DIR)/AGENTS.md
	mkdir -p $(USER_PI_DIR)/skills/essentials
	tar -C plugins/essentials/skills -cf - . | tar -C $(USER_PI_DIR)/skills/essentials -xf -
