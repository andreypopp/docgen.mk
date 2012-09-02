extracttpldep	= $(shell cat $1 \
								| grep '{% \+extends' \
								| sed -E 's/{% +extends +"([^"]+)" +%}/\1/')

BUILDALL      := $(BUILDALL:%.jinja2=%)

$(BUILD)/%: $(SRC)/%.jinja2
	$(call prelude)
	$(BIN)/jinja2 --metadata $(METADATA) $< > $@
