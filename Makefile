CMD     = /usr/bin/docker
CHECKER = /usr/bin/vlmcs
IMAGER  = mogeko/vlmcsd
VERSION = svn1113

.PHONY: all build run test

all: build run

build:
	@$(CMD) build . --tag $(IMAGER) --build-arg VERSION=$(VERSION)

run: id := $(shell $(CMD) run -d -p 1688:1688 $(IMAGER))
run:
	@$(CHECKER) && $(CMD) rm -f $(id)

help: id := $(shell head -200 /dev/urandom | cksum | cut -f1 -d " ")
help:
	@-$(CMD) run -it --name $(id) $(IMAGER) -h
	@$(CMD) rm -f $(id)

test: run
