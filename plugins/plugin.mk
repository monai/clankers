SCRIPTS := $(dir $(lastword $(MAKEFILE_LIST)))scripts

SKILL_FILES := $(if $(SKILLS),$(patsubst $(SOURCE_SKILLS)/%,%,$(shell find $(SKILLS:%=$(SOURCE_SKILLS)/%) -type f ! -name .DS_Store)))
AGENT_FILES := $(if $(wildcard $(SOURCE_AGENTS)),$(patsubst $(SOURCE_AGENTS)/%,%,$(shell find $(SOURCE_AGENTS) -type f ! -name .DS_Store)))
DISABLED_SKILLS := $(if $(SKILLS),$(patsubst $(SOURCE_SKILLS)/%/SKILL.md,%,$(shell awk -f $(SCRIPTS)/model-invocation-disabled.awk $(SKILLS:%=$(SOURCE_SKILLS)/%/SKILL.md))))

CLAUDE_SKILL_FILES := $(SKILL_FILES:%=claude/skills/%)
CODEX_SKILL_MDS := $(SKILLS:%=codex/skills/%/SKILL.md)
CODEX_POLICIES := $(DISABLED_SKILLS:%=codex/skills/%/agents/openai.yaml)
CODEX_SKILL_FILES := $(filter-out $(CODEX_SKILL_MDS) $(CODEX_POLICIES),$(SKILL_FILES:%=codex/skills/%))

CLAUDE_FILES := claude/.claude-plugin/plugin.json $(CLAUDE_SKILL_FILES) $(AGENT_FILES:%=claude/agents/%)
CODEX_FILES := codex/.codex-plugin/plugin.json $(CODEX_SKILL_MDS) $(CODEX_POLICIES) $(CODEX_SKILL_FILES) $(AGENT_FILES:%=codex/agents/%)

.PHONY: plugin
.SECONDEXPANSION:

plugin: $(CLAUDE_FILES) $(CODEX_FILES)

claude/.claude-plugin/plugin.json: $(SOURCE_MANIFEST)
	@mkdir -p $(@D)
	jq --args 'if has("agents") then .agents = $$ARGS.positional else . end' $(sort $(filter %.md,$(AGENT_FILES:%=./agents/%))) < $< > $@

codex/.codex-plugin/plugin.json: $(SOURCE_MANIFEST)
	@mkdir -p $(@D)
	cp $< $@

$(CLAUDE_SKILL_FILES): claude/skills/%: $(SOURCE_SKILLS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CODEX_SKILL_FILES): codex/skills/%: $(SOURCE_SKILLS)/%
	@mkdir -p $(@D)
	cp $< $@

$(AGENT_FILES:%=claude/agents/%): claude/agents/%: $(SOURCE_AGENTS)/%
	@mkdir -p $(@D)
	cp $< $@

$(AGENT_FILES:%=codex/agents/%): codex/agents/%: $(SOURCE_AGENTS)/%
	@mkdir -p $(@D)
	cp $< $@

$(CODEX_SKILL_MDS): codex/skills/%/SKILL.md: $(SOURCE_SKILLS)/%/SKILL.md $(SCRIPTS)/strip-model-invocation.awk
	@mkdir -p $(@D)
	awk -f $(SCRIPTS)/strip-model-invocation.awk $< > $@

$(CODEX_POLICIES): codex/skills/%/agents/openai.yaml: $$(wildcard $(SOURCE_SKILLS)/$$*/agents/openai.yaml) $(SCRIPTS)/disable-implicit-invocation.awk
	@mkdir -p $(@D)
	awk -f $(SCRIPTS)/disable-implicit-invocation.awk $(filter %.yaml,$^) /dev/null > $@
