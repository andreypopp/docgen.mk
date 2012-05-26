# docgen.prelude

SRC           ?= src
BUILD         ?= build
BIN           ?= bin
META          ?= $(BUILD)/.docgen
METADATA      ?= $(META)/metadata.yaml
SETTINGS      ?= settings.yaml

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
SRCALL        = $(filter-out $(IGNORE:%=$(SRC)/%), $(shell find $(SRC) -type f))
BUILDALL      := $(SRCALL:$(SRC)/%=$(BUILD)/%) $(DEPS)
METAALL       :=

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = \
	$(call status)\
	$(call ensuredir)

# docgen.markdown

BUILDALL      := $(BUILDALL:%.md=%.html)
METAALL       := $(METAALL) $(SRCALL:$(SRC)/%.md=$(META)/%.html)

$(BUILD)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown $< > $@

$(META)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown --metadata $< > $@

# docgen.core

all: | metadata build

build: $(BUILDALL)

$(METADATA): $(METAALL)
	@$(info generating $(METADATA))
	@$(call ensuredir)
	@cat $(SETTINGS)  >> $(METADATA)
	@echo "pages:"    >> $(METADATA)
	@$(foreach f,$(shell [ -d $(META) ] && find $(META) -type f),\
		echo "$(f:$(META)/%=%):" | sed -E 's/^/  /'   >> $(METADATA);\
		cat $(f)                 | sed -E 's/^/    /' >> $(METADATA);\
		)

metadata: $(METADATA)

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

$(BUILD)/%: $(SRC)/%
	$(call prelude)
	@cp $< $@
