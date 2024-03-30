.PHONY: all clean

# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
        OSFLAG = WIN32
else
        UNAME_S := $(shell uname -s)
        ifeq ($(UNAME_S),Linux)
                OSFLAG = LINUX
        endif
        ifeq ($(UNAME_S),Darwin)
                OSFLAG = OSX
        endif
endif

PANDOC_CMD = lua ${LITPD_HOME}/litpd.lua 
PANDOC_OPTS_HTML = --to=html --standalone --toc

BUILD_DIR = dist

all: $(BUILD_DIR) $(BUILD_DIR)/quadtree-sim.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# TODO: since the lua files are currently generated in the current folder,
# we need to move them to the build folder. This should not be necessary.

$(BUILD_DIR)/%.html: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS_HTML) -o $@
	mv *.lua $(BUILD_DIR)/

$(BUILD_DIR)/%.pdf: %.md
	$(PANDOC_CMD) $< $(PANDOC_OPTS_PDF) -o $@
	mv *.lua $(BUILD_DIR)/

clean:
	rm -f $(BUILD_DIR)/*.html
	rm -f $(BUILD_DIR)/*.pdf
	rm -f $(BUILD_DIR)/*.lua

run:
	love dist/

open:
ifeq ($(OSFLAG),WIN32)
	cygstart $(BUILD_DIR)/quadtree-sim.html
else
	open $(BUILD_DIR)/quadtree-sim.html
endif