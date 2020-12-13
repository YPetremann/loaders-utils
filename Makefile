.SILENT:
.PHONY: all version debug datestamp prepackage prepublish publish pregenerated
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

SHELL = bash

LUAS := $(call rwildcard,,*.lua)
LUAS := $(filter-out generated.lua, $(LUAS))

PNGS := $(call rwildcard,,*.png)

bin/%:
	@echo -n "executable $* is "
	@which $* &> /dev/null && echo "available" || (echo "not available" && exit 1)
all:
	@echo targets: version debug datestamp prepackage prepublish publish
version:
	@echo Version Done
debug: generated.lua
	@echo Debug Done
datestamp: generated.lua
	@echo Datestamp Done
prepackage: generated.lua
	@echo Prepackage Done
prepublish:
	@echo Prepublish Done
publish:
	@echo Publish Done
generated.lua: $(PNGS) $(LUAS) Makefile bin/identify
	@echo GEN: PRE
	$(file >generated.lua.txt,return {)
	$(file >>generated.lua.txt,  lua={)
	$(foreach LUA,$(LUAS),$(file >>generated.lua.txt,    ["$(subst /,.,$(LUA:.lua=))"]=true,))
	$(file >>generated.lua.txt,  },)
	$(file >>generated.lua.txt,  png={)
	$(foreach PNG,$(PNGS),$(file >>generated.lua.txt,    ["$(PNG)"]=$(shell identify -format "{%w, %h}" $(PNG)),))
	$(file >>generated.lua.txt,  },)
	$(file >>generated.lua.txt,})
	@mv generated.lua.txt generated.lua
	@echo GEN: POST