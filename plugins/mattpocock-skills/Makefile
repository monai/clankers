UPSTREAM := ../upstream/mattpocock-skills
SOURCE_MANIFEST := $(UPSTREAM)/.claude-plugin/plugin.json
SOURCE_SKILLS := $(UPSTREAM)/skills
SKILLS := $(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/engineering/*/SKILL.md $(SOURCE_SKILLS)/productivity/*/SKILL.md)))

.PHONY: all clean

all: $(SOURCE_MANIFEST)
	$(MAKE) clean
	$(MAKE) plugin

$(SOURCE_MANIFEST):
	git -C ../.. submodule update --init -- plugins/upstream/mattpocock-skills

clean:
	$(RM) -r claude codex $(PI_DIR)

include ../plugin.mk
