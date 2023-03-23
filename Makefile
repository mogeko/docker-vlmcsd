IMAGE_NAME ?= vlmcsd
IMAGE_PORT ?= 1688
CMD        ?= docker

.PHONY: all build buildah run test

all: build

build: api     := https://api.github.com/repos/Wind4/vlmcsd/tags
build: version := $(shell curl -sSL $(api) | jq -r '.[0].name')
build:
	@$(CMD) build --tag $(IMAGE_NAME) --build-arg VERSION=$(version) .

help:
	@-$(CMD) run -it --rm $(IMAGE_NAME) -h

CHECKER ?= /usr/bin/env vlmcs
run: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
run: build
	@$(CMD) run -d --name $(id) -p $(IMAGE_PORT):1688 $(IMAGE_NAME)
	@$(CHECKER) 127.0.0.1:$(IMAGE_PORT)
	@$(CMD) rm -f $(id)

test: run

buildah:
ifneq ($(wildcard /usr/bin/buildah),)
	@CMD=buildah $(MAKE) build
else
	$(error "This target requires buildah")
endif
