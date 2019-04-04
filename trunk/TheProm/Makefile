ABS_PATH = /Users/bart/tmp/altprom/TheProm
MAIN_SRC = $(ABS_PATH)/src/Main.mxml
SRC_PATH = $(ABS_PATH)/src/
OUTPUT_BIN = $(ABS_PATH)/bin/PromWeek.swf
MXMLC = mxmlc
MXMLC_OPT = \
	-compiler.debug \
	-static-link-runtime-shared-libraries \
	-default-size 760 600 \
	-compiler.optimize \
	-compiler.include-libraries $(shell echo $(ABS_PATH)/data/icons/relationships/*.swc) $(shell echo $(ABS_PATH)/data/characters/*.swc) $(ABS_PATH)/lib/CiF.swc $(ABS_PATH)/lib/FacebookGraphAPI.swc

#LIBRARY_PATH := $(shell xpath PromWeek.as3proj "project/libraryPaths/element/@path" 2>/dev/null | sed -e 's/path="\([^"]*\)"/\1/g' | sed -e 's/\\/\//g')

all:
	$(MXMLC) $(MXMLC_OPT) -output $(OUTPUT_BIN) -sp $(SRC_PATH) -- $(MAIN_SRC)

backend:
	$(MXMLC) $(MXMLC_OPT) -output $(OUTPUT_BIN) -sp $(SRC_PATH) -- src/BackendTest.mxml