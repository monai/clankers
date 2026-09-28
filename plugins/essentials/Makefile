SOURCE_MANIFEST := src/plugin.json
SOURCE_SKILLS := src/skills
SOURCE_AGENTS := src/agents
EXCLUDED_AGENTS := worker scout
SKILLS := $(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/*/SKILL.md)))

.PHONY: all clean

all: plugin

clean:
	$(RM) -r claude codex pi

include ../plugin.mk
