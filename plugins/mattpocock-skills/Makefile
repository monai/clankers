.PHONY: all adopt clean

MATTPOCOCK_SKILLS_TARGET := build/mattpocock-skill
MATTPOCOCK_SKILLS_DIR := $(MATTPOCOCK_SKILLS_TARGET)/skills
MATTPOCOCK_CLAUDE_MANIFEST_SOURCE := $(MATTPOCOCK_SKILLS_TARGET)/.claude-plugin/plugin.json
CLAUDE_MANIFEST_TARGET := .claude-plugin/plugin.json
SKILLS_DIR := skills

ENGINEERING_SKILL_SOURCES := $(shell find $(MATTPOCOCK_SKILLS_DIR)/engineering -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
PRODUCTIVITY_SKILL_SOURCES := $(shell find $(MATTPOCOCK_SKILLS_DIR)/productivity -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

ENGINEERING_SKILL_TARGETS := $(patsubst $(MATTPOCOCK_SKILLS_DIR)/engineering/%,$(SKILLS_DIR)/engineering/%,$(ENGINEERING_SKILL_SOURCES))
PRODUCTIVITY_SKILL_TARGETS := $(patsubst $(MATTPOCOCK_SKILLS_DIR)/productivity/%,$(SKILLS_DIR)/productivity/%,$(PRODUCTIVITY_SKILL_SOURCES))
SKILL_TARGETS := $(ENGINEERING_SKILL_TARGETS) $(PRODUCTIVITY_SKILL_TARGETS)
SKILL_CATEGORY_DIRS := $(SKILLS_DIR)/engineering $(SKILLS_DIR)/productivity

all: $(MATTPOCOCK_SKILLS_TARGET)
	$(MAKE) adopt

adopt: $(SKILL_TARGETS) $(CLAUDE_MANIFEST_TARGET)

$(MATTPOCOCK_SKILLS_TARGET):
	mkdir -p $(@D)
	git clone --depth=1 https://github.com/mattpocock/skills.git $@

$(SKILL_CATEGORY_DIRS):
	mkdir -p $@

$(ENGINEERING_SKILL_TARGETS): $(SKILLS_DIR)/engineering/%: $(MATTPOCOCK_SKILLS_DIR)/engineering/% | $(SKILLS_DIR)/engineering
	$(RM) -r $@
	cp -r $< $@
	sed '/^disable-model-invocation: true$$/d' $@/SKILL.md > $@/SKILL.md.tmp && mv $@/SKILL.md.tmp $@/SKILL.md

$(PRODUCTIVITY_SKILL_TARGETS): $(SKILLS_DIR)/productivity/%: $(MATTPOCOCK_SKILLS_DIR)/productivity/% | $(SKILLS_DIR)/productivity
	$(RM) -r $@
	cp -r $< $@
	sed '/^disable-model-invocation: true$$/d' $@/SKILL.md > $@/SKILL.md.tmp && mv $@/SKILL.md.tmp $@/SKILL.md

$(CLAUDE_MANIFEST_TARGET): $(MATTPOCOCK_CLAUDE_MANIFEST_SOURCE)
	cp $< $@

clean:
	$(RM) -r $(MATTPOCOCK_SKILLS_TARGET) $(SKILLS_DIR)
