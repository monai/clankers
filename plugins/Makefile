UPSTREAMS := plugins/upstream/mattpocock-skills plugins/upstream/cursor-plugins
PLUGINS := essentials mattpocock-skills pstack

.PHONY: all clean rebuild update $(PLUGINS) $(PLUGINS:%=clean-%)

all: $(PLUGINS)

$(PLUGINS):
	$(MAKE) -C $@

clean: $(PLUGINS:%=clean-%)

$(PLUGINS:%=clean-%):
	$(MAKE) -C $(@:clean-%=%) clean

rebuild: all

update:
	git -C .. submodule update --init --remote -- $(UPSTREAMS)
	$(MAKE) all
