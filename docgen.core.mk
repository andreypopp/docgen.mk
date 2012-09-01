all:
	@$(MAKE) -s metadata
	@$(MAKE) -s build

clean:
	$(info cleaning up)
	@rm -rf $(BUILD)

build: $(BUILDALL)

$(METADATA): $(METAALL)
	$(info generating $(METADATA))
	$(call ensuredir)
	> $(METADATA)
	[ -f $(SETTINGS) ] && (cat $(SETTINGS) >> $(METADATA)); true
	echo "pages:"    >> $(METADATA)
	$(foreach f,$(shell [ -d $(META) ] && find $(META) -type f),\
		echo "$(f:$(META)/%=%):" | sed -E 's/^/  /'   >> $(METADATA);\
		cat $(f)                 | sed -E 's/^/    /' >> $(METADATA);\
		)

metadata: $(METADATA)

$(BUILD)/%: $(SRC)/%
	$(call prelude)
	cp $< $@
