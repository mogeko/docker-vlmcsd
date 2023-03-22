OBJ_DIR := $(PWD)/vlmcsd-source
CC      := /usr/bin/clang

.PHONY: all compile clean buildah

all: compile

$(OBJ_DIR): repository := https://github.com/Wind4/vlmcsd.git
$(OBJ_DIR): api        := https://api.github.com/repos/Wind4/vlmcsd/tags
$(OBJ_DIR): version    := $(shell curl -sSL $(api) | jq -r '.[0].name')
$(OBJ_DIR):
	@git clone --depth 1 --branch $(version) $(repository) $@

compile: $(OBJ_DIR) $(OBJ_DIR)/src/vlmcsd.c
	@CC=$(CC) $(MAKE) -C $(OBJ_DIR) -j$(shell nproc)

clean: $(OBJ_DIR)
	@$(RM) -rf $(OBJ_DIR)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
buildah: image := gcr.io/distroless/base-nossl-debian11:nonroot
buildah: ctr   := $(shell buildah from $(image))
buildah: compile
	@buildah config --label maintainer="Zheng Junyi <zhengjunyi@live.comn>" $(ctr)
	@buildah copy --chmod 755 $(ctr) $(OBJ_DIR)/bin/vlmcsd /usr/bin/vlmcsd
	@buildah config --port 1688 $(ctr)
	@buildah config --entrypoint '["/usr/bin/vlmcsd"]' $(ctr)
	@buildah config --cmd '["-D", "-d", "-e" ]' $(ctr)
	@buildah commit --format docker $(ctr) vlmcsd
else
buildah:
	@echo "This target is only available on Linux"
endif
