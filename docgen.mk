# docgen.prelude

.PHONY: all

SRC           = src
BUILD         = build
IGNORE        = .% %.mk Makefile bin/%
IGNORE_IMPL   = $(patsubst %,$(SRC)/%,$(IGNORE))
SRCALL        = $(filter-out $(IGNORE_IMPL),$(shell find $(SRC) -type f))
SRCPROCESSED  =
BUILDALL      =

# docgen.markdown

MD_SRC        = $(filter %.md, $(SRCALL))
MD_BUILD      = $(patsubst $(SRC)/%.md,$(BUILD)/%.html,$(MD_SRC))
MD_RENDER     = python -c "import markdown; md = markdown.Markdown(); md.convertFile('$(1)', '$(2)')"

BUILDALL      := $(BUILDALL) $(MD_BUILD)
SRCPROCESSED  := $(SRCPROCESSED) $(MD_SRC)

$(BUILD)/%.html: $(SRC)/%.md
	$(info processing $<)
	@mkdir -p $(dir $@)
	@$(call MD_RENDER,$<,$@)

# docgen.code

BUILDALL      := \
	$(BUILDALL) \
	$(patsubst $(SRC)/%,$(BUILD)/%,$(filter-out $(SRCPROCESSED),$(SRCALL)))

all: $(BUILDALL)

clean:
	$(info removing $(BUILD))
	@rm -rf $(BUILD)

$(BUILD)/%: $(SRC)/%
	$(info processing $<)
	@mkdir -p $(dir $@)
	@cp $< $@
