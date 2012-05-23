# docgen.prelude

.PHONY: all build metadata clean

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
IGNORE_IMPL   = $(patsubst %,$(SRC)/%,$(IGNORE))
SRCALL        = $(filter-out $(IGNORE_IMPL),$(shell find $(SRC) -type f))
SRCPROCESSED  =
BUILDALL      := $(DEPS)
METADATA			= $(BUILD)/.docgen

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

# docgen.core

BUILDALL      := \
	$(BUILDALL) \
	$(patsubst $(SRC)/%,$(BUILD)/%,$(filter-out $(SRCPROCESSED),$(SRCALL)))

build: $(BUILDALL)

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

metadata:
	$(info processing metadata)
	@mkdir -p $(METADATA)

all:
	@$(MAKE) metadata
	@$(MAKE) build

$(BUILD)/%: $(SRC)/%
	$(call status)
	@mkdir -p $(dir $@)
	@cp $< $@
