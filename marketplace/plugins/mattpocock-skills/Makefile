.PHONY: all adopt clean

MATTPOCOCK_SKILLS_TARGET := build/mattpocock-skill
MATTPOCOCK_SKILLS_DIR := $(MATTPOCOCK_SKILLS_TARGET)/skills
SKILLS_DIR := skills

ENGINEERING_SKILL_SOURCES := $(wildcard $(MATTPOCOCK_SKILLS_DIR)/engineering/*/)
PRODUCTIVITY_SKILL_SOURCES := $(wildcard $(MATTPOCOCK_SKILLS_DIR)/productivity/*/)

ENGINEERING_SKILL_TARGETS := $(patsubst $(MATTPOCOCK_SKILLS_DIR)/engineering/%/,$(SKILLS_DIR)/%,$(ENGINEERING_SKILL_SOURCES))
PRODUCTIVITY_SKILL_TARGETS := $(patsubst $(MATTPOCOCK_SKILLS_DIR)/productivity/%/,$(SKILLS_DIR)/%,$(PRODUCTIVITY_SKILL_SOURCES))
SKILL_TARGETS := $(ENGINEERING_SKILL_TARGETS) $(PRODUCTIVITY_SKILL_TARGETS)

all: $(MATTPOCOCK_SKILLS_TARGET)
	$(MAKE) adopt

adopt: $(SKILL_TARGETS)

$(MATTPOCOCK_SKILLS_TARGET):
	mkdir -p $(@D)
	git clone --depth=1 https://github.com/mattpocock/skills.git $@

$(SKILLS_DIR):
	mkdir -p $@

$(ENGINEERING_SKILL_TARGETS): $(SKILLS_DIR)/%: $(MATTPOCOCK_SKILLS_DIR)/engineering/%/ | $(SKILLS_DIR)
	$(RM) -r $@
	cp -r $< $@
	sed -i '/^disable-model-invocation: true$$/d' $@/SKILL.md

$(PRODUCTIVITY_SKILL_TARGETS): $(SKILLS_DIR)/%: $(MATTPOCOCK_SKILLS_DIR)/productivity/%/ | $(SKILLS_DIR)
	$(RM) -r $@
	cp -r $< $@
	sed -i '/^disable-model-invocation: true$$/d' $@/SKILL.md

clean:
	$(RM) -r $(MATTPOCOCK_SKILLS_TARGET) $(SKILLS_DIR)
