# docgen.prelude

SRC           ?= src
BUILD         ?= build
BIN           ?=

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
SRCALL        = $(filter-out $(IGNORE:%=$(SRC)/%), $(shell find $(SRC) -type f))
BUILDALL      := $(SRCALL:$(SRC)/%=$(BUILD)/%) $(DEPS)

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = \
	$(call status)\
	$(call ensuredir)

# docgen.markdown

BUILDALL      := $(BUILDALL:%.md=%.html)

$(BUILD)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)markdown $< > $@

# docgen.core

all: | build

build: $(BUILDALL)

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

$(BUILD)/%: $(SRC)/%
	$(call prelude)
	@cp $< $@
