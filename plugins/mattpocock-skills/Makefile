UPSTREAM := build/mattpocock-skill
SOURCE_MANIFEST := $(UPSTREAM)/.claude-plugin/plugin.json
SOURCE_SKILLS := $(UPSTREAM)/skills
SKILLS := $(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/engineering/*/SKILL.md $(SOURCE_SKILLS)/productivity/*/SKILL.md)))

.PHONY: all clean

all: | $(SOURCE_MANIFEST)
	$(MAKE) plugin

$(SOURCE_MANIFEST):
	git clone --depth=1 https://github.com/mattpocock/skills.git $(UPSTREAM)

clean:
	$(RM) -r build claude codex

include ../plugin.mk
