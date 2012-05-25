# docgen.prelude

.PHONY: all build metadata clean

SRC           ?= src
BUILD         ?= build
BIN           ?=

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
SRCALL        = $(filter-out $(IGNORE:%=$(SRC)/%), $(shell find $(SRC) -type f))
BUILDALL      := $(DEPS) $(SRCALL:$(SRC)/%=$(BUILD)/%)
METADATA      = $(BUILD)/.docgen

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = \
	$(call status)\
	$(call ensuredir)

# docgen.markdown

BUILDALL      := $(BUILDALL:%.md=%.html)

$(BUILD)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)dg-markdown $< > $@

# docgen.core

all:
	@$(MAKE) metadata
	@$(MAKE) build

build: $(BUILDALL)

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

metadata:
	$(info processing metadata)
	@mkdir -p $(METADATA)

$(BUILD)/%: $(SRC)/%
	$(call prelude)
	@cp $< $@
