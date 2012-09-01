extracttpldep	= $(shell cat $1 \
								| grep '{% \+extends' \
								| sed -E 's/{% +extends +"([^"]+)" +%}/\1/')
define tpldep
$1: $(call extracttpldep, $1)
	touch $1
endef
BUILDALL      := $(BUILDALL:%.jinja2=%)

$(BUILD)/%: $(SRC)/%.jinja2
	$(call prelude)
	$(BIN)/jinja2 --metadata $(METADATA) $< > $@
