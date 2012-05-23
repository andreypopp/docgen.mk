# docgen.prelude

.PHONY: all

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
IGNORE_IMPL   = $(patsubst %,$(SRC)/%,$(IGNORE))
SRCALL        = $(filter-out $(IGNORE_IMPL),$(shell find $(SRC) -type f))
SRCPROCESSED  =
BUILDALL      := $(DEPS)

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = $(call status)\
								$(call ensuredir)

# docgen.markdown

MD_SRC        = $(filter %.md, $(SRCALL))
MD_BUILD      = $(patsubst $(SRC)/%.md,$(BUILD)/%.html,$(MD_SRC))
MD_RENDER     = python -c "import markdown; md = markdown.Markdown(); md.convertFile('$(1)', '$(2)')"

BUILDALL      := $(BUILDALL) $(MD_BUILD)
SRCPROCESSED  := $(SRCPROCESSED) $(MD_SRC)

$(BUILD)/%.html: $(SRC)/%.md
	$(call status)
	@mkdir -p $(dir $@)
	@$(call MD_RENDER,$<,$@)

# docgen.code

BUILDALL      := \
	$(BUILDALL) \
	$(patsubst $(SRC)/%,$(BUILD)/%,$(filter-out $(SRCPROCESSED),$(SRCALL)))

all: $(BUILDALL)

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

$(BUILD)/%: $(SRC)/%
	$(call status)
	@mkdir -p $(dir $@)
	@cp $< $@
