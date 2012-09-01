SRC           ?= src
BUILD         ?= build
BIN           ?= bin
META          ?= $(BUILD)/.docgen
METADATA      ?= $(BUILD)/.metadata.yaml
SETTINGS      ?= settings.yaml

IGNORE        := .% %.mk Makefile bin/% $(IGNORE)
SRCALL        = $(filter-out $(IGNORE:%=$(SRC)/%), $(shell find $(SRC) -type f))
BUILDALL      := $(SRCALL:$(SRC)/%=$(BUILD)/%) $(DEPS)
METAALL       :=

status        = $(info generating $@)
ensuredir     = @mkdir -p $(dir $@)
prelude       = $(call status) $(call ensuredir)
metaname      = $(@:$(BUILD)/%=$(META)/%)
tplname       = $(TEMPLATE_$(<:$(SRC)/%=%))
tpl           = $(if $(1),|$(BIN)/jinja2 -b - -m $(2) $(1),)
tplchoose     = $(if $(call tpl,$(1),$(3)),\
                $(call tpl,$(1),$(3)),$(call tpl,$(2),$(3)))
tplordefault  = $(call tplchoose,$(call tplname),$(1),$(call metaname))
