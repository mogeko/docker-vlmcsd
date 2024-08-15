IMAGE_NAME ?= vlmcsd
RUNER      ?= docker

.PHONY: all build help run test

all: build

build: api     := https://api.github.com/repos/Wind4/vlmcsd/tags
build: version := $(shell curl -sSL $(api) | jq -r '.[0].name')
build: $(PWD)/Dockerfile
ifeq ($(wildcard /usr/bin/buildah),)
	@$(RUNER) build --build-arg VERSION=$(version) -t $(IMAGE_NAME) .
else
	@buildah bud --build-arg VERSION=$(version) -t $(IMAGE_NAME) .
endif

help:
ifneq ($(shell docker images $(IMAGE_NAME) --format "{{.ID}}"),)
	@-$(RUNER) run -it --rm $(IMAGE_NAME) -h
else
	@$(MAKE) build && $(MAKE) help
endif

run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run: build
	@$(RUNER) run -d --name $(id) $(IMAGE_NAME)
	@$(RUNER) exec $(id) /usr/bin/vlmcs 0.0.0.0:1688
	@$(RUNER) rm -f $(id)

test: run
