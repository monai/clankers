MATTPOCOCK_SKILLS_DIR := ../mattpocock-skills/skills
SKILLS_DIR := skills

ADOPTED_ENGINEERING_SKILLS := \
	ask-matt \
	code-review \
	codebase-design \
	diagnosing-bugs \
	domain-modeling \
	grill-with-docs \
	implement \
	improve-codebase-architecture \
	prototype \
	research \
	resolving-merge-conflicts \
	setup-matt-pocock-skills \
	tdd \
	to-spec \
	to-tickets \
	triage \
	wayfinder \
	wizard

ADOPTED_PRODUCTIVITY_SKILLS := \
	grill-me \
	grilling

all: $(addprefix $(SKILLS_DIR)/,$(ADOPTED_ENGINEERING_SKILLS) $(ADOPTED_PRODUCTIVITY_SKILLS))

$(addprefix $(SKILLS_DIR)/,$(ADOPTED_ENGINEERING_SKILLS)): $(SKILLS_DIR)/%: $(MATTPOCOCK_SKILLS_DIR)/engineering/%
	cp -r $< $@

$(addprefix $(SKILLS_DIR)/,$(ADOPTED_PRODUCTIVITY_SKILLS)): $(SKILLS_DIR)/%: $(MATTPOCOCK_SKILLS_DIR)/productivity/%
	cp -r $< $@
