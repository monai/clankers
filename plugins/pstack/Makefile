CURSOR_REPOSITORY := build/cursor-plugins
UPSTREAM := $(CURSOR_REPOSITORY)/pstack
SOURCE_MANIFEST := $(UPSTREAM)/.cursor-plugin/plugin.json
SOURCE_SKILLS := $(UPSTREAM)/skills
SOURCE_AGENTS := $(UPSTREAM)/agents
EXCLUDED_SKILLS := setup-pstack make-bot-ui
SKILLS := $(filter-out $(EXCLUDED_SKILLS),$(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/*/SKILL.md))))
PI_NAMESPACE := pstack
CLAUDE_NOTE := In Claude Code, translate Cursor tools and models per `../poteto-mode/references/claude-code.md`.
CLAUDE_NOTE_SKILLS := architect arena automate-me create-verification-skill how interrogate maintain-verification-skill no-comments poteto-mode recall reflect show-me-your-work swarm why
CLAUDE_CODE_REFERENCE := claude/skills/poteto-mode/references/claude-code.md

.PHONY: all clean

all: | $(SOURCE_MANIFEST)
	$(MAKE) plugin

$(SOURCE_MANIFEST):
	git clone --depth=1 https://github.com/cursor/plugins.git $(CURSOR_REPOSITORY)

clean:
	$(RM) -r build claude codex pi

include ../plugin.mk

plugin: $(CLAUDE_CODE_REFERENCE)

$(CLAUDE_CODE_REFERENCE): claude-code.md
	@mkdir -p $(@D)
	cp $< $@
