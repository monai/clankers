USER_CLAUDE_DIR := $(HOME)/.claude
USER_CODEX_DIR := $(HOME)/.codex

.PHONY: install

install:
	mkdir -p $(USER_CLAUDE_DIR)
	cp -a claude/CLAUDE.md $(USER_CLAUDE_DIR)/CLAUDE.md
	cp -a claude/settings.json $(USER_CLAUDE_DIR)/settings.json

	mkdir -p $(USER_CODEX_DIR)/agents
	cp -a plugins/essentials/agents/. $(USER_CODEX_DIR)/agents/
	cp -a codex/config.toml $(USER_CODEX_DIR)/config.toml
