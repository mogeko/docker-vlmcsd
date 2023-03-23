IMAGER_NAME  := vlmcsd
VERSION      := svn1113
PORT         := 1688

CHECKER := vlmcs
CMD     := docker

.PHONY: all build run test

all: build

build:
	@$(CMD) build . --tag $(IMAGER_NAME) --build-arg VERSION=$(VERSION)

run: id := $(shell $(CMD) run -d -p $(PORT):1688 $(IMAGER_NAME))
run: build
	@$(CHECKER) 127.0.0.1:$(PORT)
	@$(CMD) rm -f $(id)

help:
	@-$(CMD) run -it --rm $(IMAGER_NAME) -h

test: run
