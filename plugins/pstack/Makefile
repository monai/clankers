.PHONY: all clean

CURSOR_REPOSITORY := build/cursor-plugins
PSTACK_SOURCE := $(CURSOR_REPOSITORY)/pstack
CURSOR_MANIFEST := $(PSTACK_SOURCE)/.cursor-plugin/plugin.json
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))

all: skills agents .codex-plugin/plugin.json .claude-plugin/plugin.json

$(CURSOR_MANIFEST):
	mkdir -p build
	git clone --depth=1 https://github.com/cursor/plugins.git $(CURSOR_REPOSITORY)

skills: $(CURSOR_MANIFEST) $(MAKEFILE_PATH)
	$(RM) -r $@
	cp -a $(PSTACK_SOURCE)/skills $@
	touch $@

agents: $(CURSOR_MANIFEST) $(MAKEFILE_PATH)
	$(RM) -r $@
	cp -a $(PSTACK_SOURCE)/agents $@
	touch $@

.codex-plugin/plugin.json: $(CURSOR_MANIFEST) $(MAKEFILE_PATH)
	mkdir -p $(@D)
	cp $< $@

.claude-plugin/plugin.json: $(CURSOR_MANIFEST) $(MAKEFILE_PATH)
	mkdir -p $(@D)
	cp $< $@

clean:
	$(RM) -r $(CURSOR_REPOSITORY) skills agents
	$(RM) .codex-plugin/plugin.json .claude-plugin/plugin.json
