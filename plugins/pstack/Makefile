CURSOR_REPOSITORY := ../upstream/cursor-plugins
UPSTREAM := $(CURSOR_REPOSITORY)/pstack
SOURCE_MANIFEST := $(UPSTREAM)/.cursor-plugin/plugin.json
SOURCE_SKILLS := $(UPSTREAM)/skills
SOURCE_AGENTS := $(UPSTREAM)/agents
EXCLUDED_SKILLS := setup-pstack make-bot-ui
SKILLS := $(filter-out $(EXCLUDED_SKILLS),$(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/*/SKILL.md))))
PI_NAMESPACE := pstack
CLAUDE_NOTE := In Claude Code, translate Cursor tools and models per `../poteto-mode/references/claude-code.md`.
CODEX_NOTE := In Codex, translate Cursor tools and models per `../poteto-mode/references/codex.md`.
NOTE_SKILLS := architect arena automate-me create-verification-skill how interrogate maintain-verification-skill no-comments poteto-mode recall reflect show-me-your-work swarm why
CLAUDE_CODE_REFERENCE := claude/skills/poteto-mode/references/claude-code.md
CODEX_REFERENCE := codex/skills/poteto-mode/references/codex.md

.PHONY: all clean

all: $(SOURCE_MANIFEST)
	$(MAKE) clean
	$(MAKE) plugin

$(SOURCE_MANIFEST):
	git -C ../.. submodule update --init -- plugins/upstream/cursor-plugins

clean:
	$(RM) -r claude codex $(PI_DIR)

include ../plugin.mk

plugin: $(CLAUDE_CODE_REFERENCE) $(CODEX_REFERENCE)

$(CLAUDE_CODE_REFERENCE): claude-code.md
	@mkdir -p $(@D)
	$(call copy,$<,$@)

$(CODEX_REFERENCE): codex.md
	@mkdir -p $(@D)
	$(call copy,$<,$@)
