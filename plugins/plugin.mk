SCRIPTS := $(dir $(lastword $(MAKEFILE_LIST)))scripts

SKILL_FILES := $(if $(SKILLS),$(patsubst $(SOURCE_SKILLS)/%,%,$(shell find $(SKILLS:%=$(SOURCE_SKILLS)/%) -type f ! -name .DS_Store)))
AGENT_FILES := $(filter-out $(EXCLUDED_AGENTS:%=%.md),$(if $(wildcard $(SOURCE_AGENTS)),$(patsubst $(SOURCE_AGENTS)/%,%,$(shell find $(SOURCE_AGENTS) -type f ! -name .DS_Store))))
DISABLED_SKILLS := $(if $(SKILLS),$(patsubst $(SOURCE_SKILLS)/%/SKILL.md,%,$(shell awk -f $(SCRIPTS)/model-invocation-disabled.awk $(SKILLS:%=$(SOURCE_SKILLS)/%/SKILL.md))))

CLAUDE_SKILL_MDS := $(SKILLS:%=claude/skills/%/SKILL.md)
CLAUDE_SKILL_FILES := $(filter-out $(CLAUDE_SKILL_MDS),$(SKILL_FILES:%=claude/skills/%))
CLAUDE_AGENT_MDS := $(filter %.md,$(AGENT_FILES:%=claude/agents/%))
CLAUDE_AGENT_FILES := $(filter-out $(CLAUDE_AGENT_MDS),$(AGENT_FILES:%=claude/agents/%))
CODEX_SKILL_MDS := $(SKILLS:%=codex/skills/%/SKILL.md)
CODEX_POLICIES := $(DISABLED_SKILLS:%=codex/skills/%/agents/openai.yaml)
CODEX_SKILL_FILES := $(filter-out $(CODEX_SKILL_MDS) $(CODEX_POLICIES),$(SKILL_FILES:%=codex/skills/%))
CODEX_AGENT_TOMLS := $(patsubst %.md,codex/agents/%.toml,$(filter %.md,$(AGENT_FILES)))
CODEX_AGENT_FILES := $(filter-out %.md,$(AGENT_FILES:%=codex/agents/%))

CLAUDE_FILES := claude/.claude-plugin/plugin.json $(CLAUDE_SKILL_MDS) $(CLAUDE_SKILL_FILES) $(CLAUDE_AGENT_MDS) $(CLAUDE_AGENT_FILES)
CODEX_FILES := codex/.codex-plugin/plugin.json $(CODEX_SKILL_MDS) $(CODEX_POLICIES) $(CODEX_SKILL_FILES) $(CODEX_AGENT_TOMLS) $(CODEX_AGENT_FILES)

pi_skill_name = $(if $(PI_NAMESPACE),$(PI_NAMESPACE)-)$(notdir $(1))
PI_SKILL_MDS := $(SKILLS:%=pi/skills/%/SKILL.md)
PI_SKILL_FILES := $(filter-out $(PI_SKILL_MDS),$(SKILL_FILES:%=pi/skills/%))
PI_FILES := $(PI_SKILL_MDS) $(PI_SKILL_FILES)

.PHONY: plugin
.SECONDEXPANSION:

plugin: $(CLAUDE_FILES) $(CODEX_FILES) $(PI_FILES)

claude/.claude-plugin/plugin.json: $(SOURCE_MANIFEST)
	@mkdir -p $(@D)
	jq --args 'if has("agents") then .agents = $$ARGS.positional else . end' $(sort $(filter %.md,$(AGENT_FILES:%=./agents/%))) < $< > $@

codex/.codex-plugin/plugin.json: $(SOURCE_MANIFEST)
	@mkdir -p $(@D)
	jq 'del(.agents)' < $< > $@

$(CLAUDE_SKILL_MDS): claude/skills/%/SKILL.md: $(SOURCE_SKILLS)/%/SKILL.md $(SCRIPTS)/set-name.awk $(SCRIPTS)/add-note.awk
	@mkdir -p $(@D)
	awk -v name=$(notdir $*) -f $(SCRIPTS)/set-name.awk $< | awk -v note='$(if $(filter $*,$(NOTE_SKILLS)),$(CLAUDE_NOTE))' -f $(SCRIPTS)/add-note.awk > $@

$(CLAUDE_SKILL_FILES): claude/skills/%: $(SOURCE_SKILLS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CODEX_SKILL_FILES): codex/skills/%: $(SOURCE_SKILLS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CLAUDE_AGENT_MDS): claude/agents/%.md: $(SOURCE_AGENTS)/%.md $(SCRIPTS)/set-name.awk
	@mkdir -p $(@D)
	awk -v name=$(notdir $*) -f $(SCRIPTS)/set-name.awk $< > $@

$(CLAUDE_AGENT_FILES): claude/agents/%: $(SOURCE_AGENTS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CODEX_AGENT_TOMLS): codex/agents/%.toml: $(SOURCE_AGENTS)/%.md $(SCRIPTS)/agent-to-toml.awk
	@mkdir -p $(@D)
	awk -v name=$(notdir $*) -f $(SCRIPTS)/agent-to-toml.awk $< > $@

$(CODEX_AGENT_FILES): codex/agents/%: $(SOURCE_AGENTS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CODEX_SKILL_MDS): codex/skills/%/SKILL.md: $(SOURCE_SKILLS)/%/SKILL.md $(SCRIPTS)/strip-model-invocation.awk $(SCRIPTS)/set-name.awk $(SCRIPTS)/add-note.awk
	@mkdir -p $(@D)
	awk -f $(SCRIPTS)/strip-model-invocation.awk $< | awk -v name=$(notdir $*) -f $(SCRIPTS)/set-name.awk | awk -v note='$(if $(filter $*,$(NOTE_SKILLS)),$(CODEX_NOTE))' -f $(SCRIPTS)/add-note.awk > $@

$(CODEX_POLICIES): codex/skills/%/agents/openai.yaml: $$(wildcard $(SOURCE_SKILLS)/$$*/agents/openai.yaml) $(SCRIPTS)/disable-implicit-invocation.awk
	@mkdir -p $(@D)
	awk -f $(SCRIPTS)/disable-implicit-invocation.awk $(filter %.yaml,$^) /dev/null > $@

$(PI_SKILL_MDS): pi/skills/%/SKILL.md: $(SOURCE_SKILLS)/%/SKILL.md $(SCRIPTS)/set-name.awk
	@mkdir -p $(@D)
	awk -v name=$(call pi_skill_name,$*) -f $(SCRIPTS)/set-name.awk $< > $@

$(PI_SKILL_FILES): pi/skills/%: $(SOURCE_SKILLS)/%
	@mkdir -p $(@D)
	cp $< $@
