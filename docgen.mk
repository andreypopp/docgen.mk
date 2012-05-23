# docgen

.PHONY: all

SRC						= src
BUILD					= build
IGNORE				= .% %.mk Makefile bin/%
IGNORE_IMPL 	= $(patsubst %,$(SRC)/%,$(IGNORE))
SRCALL				= $(filter-out $(IGNORE_IMPL),$(shell find . -type f))
BUILDALL			=

# docgen.markdown

MD_SRC 				= $(filter %.md, $(SRCALL))
MD_BUILD			= $(patsubst ./$(SRC)/%.md,./$(BUILD)/%.html,$(MD_SRC))
MD_RENDER			= python -c "import markdown; md = markdown.Markdown(); md.convertFile('$(1)', '$(2)')"

BUILDALL			:= $(BUILDALL) $(MD_BUILD)

all: $(BUILDALL)

clean:
	rm -rf $(BUILD)

$(BUILD)/%.html: $(SRC)/%.md
	mkdir -p $(dir $@)
	$(call MD_RENDER,$<,$@)
