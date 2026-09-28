CURSOR_REPOSITORY := build/cursor-plugins
UPSTREAM := $(CURSOR_REPOSITORY)/pstack
SOURCE_MANIFEST := $(UPSTREAM)/.cursor-plugin/plugin.json
SOURCE_SKILLS := $(UPSTREAM)/skills
SOURCE_AGENTS := $(UPSTREAM)/agents
PI_NAMESPACE := pstack
PI_UNNAMESPACED_SKILLS := setup-pstack
SKILLS := $(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/*/SKILL.md)))

.PHONY: all clean

all: | $(SOURCE_MANIFEST)
	$(MAKE) plugin

$(SOURCE_MANIFEST):
	git clone --depth=1 https://github.com/cursor/plugins.git $(CURSOR_REPOSITORY)

clean:
	$(RM) -r build claude codex pi

include ../plugin.mk
