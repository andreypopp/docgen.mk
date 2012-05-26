SRC       := src
BUILD     := build
IGNORE    := templates/%
DEPS      := $(BUILD)/rss.xml

include docgen.mk

$(BUILD)/rss.xml: $(METADATA)
	$(call prelude)
	@$(BIN)/jinja2 -m $(METADATA) -p /rss.xml $(SRC)/templates/rss.xml > $@
