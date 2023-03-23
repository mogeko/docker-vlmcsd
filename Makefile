IMAGE_NAME ?= vlmcsd
IMAGE_PORT ?= 1688
RUNER      ?= docker

.PHONY: all build buildah run test

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
	@-$(RUNER) run -it --rm $(IMAGE_NAME) -h

CHECKER ?= /usr/bin/env vlmcs
run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run: build
	@$(RUNER) run -d --name $(id) -p $(IMAGE_PORT):1688 $(IMAGE_NAME)
	@$(CHECKER) 127.0.0.1:$(IMAGE_PORT)
	@$(RUNER) rm -f $(id)

test: run
