# docgen.prelude

SRC           ?= src
BUILD         ?= build
BIN           ?= bin
TEMPLATES     ?= templates
META          ?= $(BUILD)/.docgen
METADATA      ?= $(META)/metadata.yaml
SETTINGS      ?= settings.yaml
HOST          ?= localhost
PORT          ?= 8000

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
SRCALL        = $(filter-out $(IGNORE:%=$(SRC)/%), $(shell find $(SRC) -type f))
BUILDALL      := $(SRCALL:$(SRC)/%=$(BUILD)/%) $(DEPS)
METAALL       :=

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = \
	$(call status)\
	$(call ensuredir)
template			= $(if $(1),|$(BIN)/jinja2 -b - -m $(METADATA) $(1),)

# docgen.markdown

BUILDALL      := $(BUILDALL:%.md=%.html)
METAALL       := $(METAALL) $(SRCALL:$(SRC)/%.md=$(META)/%.html)

$(BUILD)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown $< $(call template,$(TEMPLATE_md)) > $@

$(META)/%.html: $(SRC)/%.md
	$(call prelude)
	@$(BIN)/markdown --metadata $< > $@

# docgen.jinja2

BUILDALL      := $(BUILDALL:%.jinja2=%.html)

$(BUILD)/%.html: $(SRC)/%.jinja2
	$(call prelude)
	@$(BIN)/jinja2 --metadata $(METADATA) --templates $(TEMPLATES) $< > $@

# docgen.core

all: | metadata build

build: $(BUILDALL)

$(METADATA): $(METAALL)
	@$(info generating $(METADATA))
	@$(call ensuredir)
	# TODO: find a way to supress warning
	@-[ -f $(SETTINGS) ] && (cat $(SETTINGS) >> $(METADATA))
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

preview:
	$(info serving on $(HOST):$(PORT))
	@(cd build; python -c '\
import SimpleHTTPServer, SocketServer;\
handler = SimpleHTTPServer.SimpleHTTPRequestHandler;\
httpd = SocketServer.TCPServer(("$(HOST)", $(PORT)), handler);\
httpd.serve_forever();')
