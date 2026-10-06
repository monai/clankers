DEFAULT_DISABLE_MODEL_INVOCATION := true
SOURCE_MANIFEST := src/plugin.json
SOURCE_SKILLS := src/skills
SOURCE_AGENTS := src/agents
EXCLUDED_AGENTS := worker scout
SKILLS := $(patsubst $(SOURCE_SKILLS)/%/,%,$(dir $(wildcard $(SOURCE_SKILLS)/*/SKILL.md)))

.PHONY: all clean

all: clean
	$(MAKE) plugin

clean:
	$(RM) -r claude codex $(PI_DIR)

include ../plugin.mk
