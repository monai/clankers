PLUGINS := essentials mattpocock-skills pstack

.PHONY: all clean rebuild $(PLUGINS) $(PLUGINS:%=clean-%)

all: $(PLUGINS)

$(PLUGINS):
	$(MAKE) -C $@

clean: $(PLUGINS:%=clean-%)

$(PLUGINS:%=clean-%):
	$(MAKE) -C $(@:clean-%=%) clean

rebuild: clean
	$(MAKE) all
