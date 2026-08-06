MATTPOCOCK_SKILLS_DIR := ../mattpocock-skills/skills
SKILLS_DIR := skills
AGENT_CLAUDE_DIR := /home/agent/.claude
AGENT_AGENTS_DIR := /home/agent/.agents
HOST_CLAUDE_DIR := $(HOME)/.claude
HOST_AGENTS_DIR := $(HOME)/.agents

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

.PHONY: all install-container install-host

install-container:
	@test -n "$(CONTAINER)" || { echo "make install-container: CONTAINER is not set. Use: make install-container CONTAINER=<name>" >&2; exit 1; }
	docker exec $(CONTAINER) rm -rf $(AGENT_CLAUDE_DIR)/skills $(AGENT_AGENTS_DIR)/skills
	docker exec $(CONTAINER) mkdir -p $(AGENT_CLAUDE_DIR)/skills $(AGENT_AGENTS_DIR)/skills
	docker cp -a $(SKILLS_DIR)/. $(CONTAINER):$(AGENT_CLAUDE_DIR)/skills
	docker cp -a claude/CLAUDE.md $(CONTAINER):$(AGENT_CLAUDE_DIR)/CLAUDE.md
	docker cp -a claude/settings.json $(CONTAINER):$(AGENT_CLAUDE_DIR)/settings.json
	docker cp -a $(SKILLS_DIR)/. $(CONTAINER):$(AGENT_AGENTS_DIR)/skills
	docker cp -a claude/CLAUDE.md $(CONTAINER):$(AGENT_AGENTS_DIR)/AGENTS.md

install-host:
	rm -rf $(HOST_CLAUDE_DIR)/skills $(HOST_AGENTS_DIR)/skills
	mkdir -p $(HOST_CLAUDE_DIR)/skills $(HOST_AGENTS_DIR)/skills
	cp -a $(SKILLS_DIR)/. $(HOST_CLAUDE_DIR)/skills
	cp -a claude/CLAUDE.md $(HOST_CLAUDE_DIR)/CLAUDE.md
	cp -a claude/settings.json $(HOST_CLAUDE_DIR)/settings.json
	cp -a $(SKILLS_DIR)/. $(HOST_AGENTS_DIR)/skills
	cp -a claude/CLAUDE.md $(HOST_AGENTS_DIR)/AGENTS.md
