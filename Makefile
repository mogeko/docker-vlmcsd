VERSION := $(shell curl -sSL https://api.github.com/repos/Wind4/vlmcsd/tags | jq -r '.[0].name')
OBJ_DIR := $(PWD)/vlmcsd-source
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
ifeq ($(UNAME_S),Linux)
buildah: ctr := $(shell buildah from gcr.io/distroless/base-nossl-debian11:nonroot)
buildah: build
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
