VERSION := $(shell $(PWD)/scripts/version.sh)
OBJ_DIR := $(PWD)/vlmcsd-$(VERSION)
CC      := /usr/bin/clang

.PHONY: all build clean buildah

all: build

$(OBJ_DIR):
	@git clone --depth 1 -b $(VERSION) https://github.com/Wind4/vlmcsd.git $@

build: $(OBJ_DIR)
	@CC=$(CC) $(MAKE) -C $(OBJ_DIR) -j$(shell nproc)

clean: $(OBJ_DIR)
	@$(RM) -rf $(OBJ_DIR)

UNAME_S := $(shell uname -s)
buildah: build
ifeq ($(UNAME_S),Linux)
	@buildah unshare ./scripts/build.sh $(OBJ_DIR)
else
	@echo "This target is only available on Linux"
endif
