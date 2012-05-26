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
prelude       = $(call status) $(call ensuredir)
tplname       = $(TEMPLATE_$(<:$(SRC)/%=%))
tpl           = $(if $(1),|$(BIN)/jinja2 -b - -m $(METADATA) $(1),)
tplchoose     = $(if $(call tpl,$(1)),$(call tpl,$(1)),$(call tpl,$(2)))

# docgen.markdown

BUILDALL      := $(BUILDALL:%.md=%.html)
METAALL       := $(METAALL) $(SRCALL:$(SRC)/%.md=$(META)/%.html)

$(BUILD)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown $< $(call tplchoose,$(call tplname),$(TEMPLATE_md)) > $@

$(META)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown --metadata $< > $@

# docgen.jinja2

BUILDALL      := $(BUILDALL:%.jinja2=%.html)

$(BUILD)/%.html: $(SRC)/%.jinja2
	$(call prelude)
	@$(BIN)/jinja2 --metadata $(METADATA) $< > $@

# docgen.core

all:
	@$(MAKE) -s metadata
	@$(MAKE) -s build

build: $(BUILDALL)

$(METADATA): $(METAALL)
	@$(info generating $(METADATA))
	@$(call ensuredir)
	@[ -f $(SETTINGS) ] && (cat $(SETTINGS) >> $(METADATA)); true
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
