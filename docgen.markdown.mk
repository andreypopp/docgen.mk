BUILDALL      := $(BUILDALL:%.md=%.html)
METAALL       := $(METAALL) $(SRCALL:$(SRC)/%.md=$(META)/%.html)

$(BUILD)/%.html: $(SRC)/%.md $(TEMPLATE_md)
	$(call prelude)
	$(BIN)/markdown $< $(call tplordefault,$(TEMPLATE_md)) > $@

$(META)/%.html: $(SRC)/%.md
	$(call prelude)
	$(BIN)/markdown --metadata $< > $@
