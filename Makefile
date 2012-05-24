BINPATH   := ./bin/
SRC       := src
BUILD     := build
IGNORE    := templates/%
DEPS      := $(BUILD)/rss.xml

include docgen.mk

$(BUILD)/rss.xml:
	$(call prelude)
	@touch $@
