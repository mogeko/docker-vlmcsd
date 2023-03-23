IMAGE_NAME := vlmcsd
IMAGE_PORT := 1688

CHECKER := vlmcs
CMD     := docker

.PHONY: all build run test

all: build

build: api     := https://api.github.com/repos/Wind4/vlmcsd/tags
build: version := $(shell curl -sSL $(api) | jq -r '.[0].name')
build:
	@$(CMD) build . --tag $(IMAGE_NAME) --build-arg VERSION=$(version)

run: id := $(shell $(CMD) run -d -p $(IMAGE_PORT):1688 $(IMAGE_NAME))
run: build
	@$(CHECKER) 127.0.0.1:$(IMAGE_PORT)
	@$(CMD) rm -f $(id)

help:
	@-$(CMD) run -it --rm $(IMAGE_NAME) -h

test: run
