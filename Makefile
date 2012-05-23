BINPATH   := ./bin/
SRC       := src
BUILD     := build
IGNORE    := templates/%
DEPS      := $(BUILD)/rss.xml

$(BUILD)/rss.xml:
	$(call prelude)
	@touch $@

include docgen.mk
