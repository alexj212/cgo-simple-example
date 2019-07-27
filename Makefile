export DATE := $(shell date +%Y.%m.%d-%H%M)
export LATEST_COMMIT := $(shell git log --pretty=format:'%h' -n 1)
export BRANCH := $(shell git branch |grep -v "no branch"| grep \*|cut -d ' ' -f2)
export BUILT_ON_IP := $(shell [ $$(uname) = Linux ] && hostname -i || hostname )

export BUILT_ON_OS=$(shell uname -a)
ifeq ($(BRANCH),)
BRANCH := master
endif

export COMMIT_CNT := $(shell git rev-list HEAD | wc -l | sed 's/ //g' )
export BUILD_NUMBER := ${BRANCH}-${COMMIT_CNT}
export CGO_LDFLAGS=-Wno-error $(shell pkg-config --libs libavformat )
export CGO_CFLAGS=$(shell pkg-config --cflags-only-I libavformat )
export COMPILE_LDFLAGS=-s -X "main.DATE=${DATE}" \
                          -X "main.LATEST_COMMIT=${LATEST_COMMIT}" \
                          -X "main.BUILD_NUMBER=${BUILD_NUMBER}" \
                          -X "main.BUILT_ON_IP=${BUILT_ON_IP}" \
                          -X "main.BUILT_ON_OS=${BUILT_ON_OS}"



build_info: ## Build the container
	@echo ''
	@echo '---------------------------------------------------------'
	@echo 'BUILT_ON_IP      $(BUILT_ON_IP)'
	@echo 'BUILT_ON_OS      $(BUILT_ON_OS)'
	@echo 'DATE             $(DATE)'
	@echo 'LATEST_COMMIT    $(LATEST_COMMIT)'
	@echo 'BRANCH           $(BRANCH)'
	@echo 'COMMIT_CNT       $(COMMIT_CNT)'
	@echo 'BUILD_NUMBER     $(BUILD_NUMBER)'
	@echo 'COMPILE_LDFLAGS  $(COMPILE_LDFLAGS)'
	@echo 'CGO_LDFLAGS      $(CGO_LDFLAGS)'
	@echo 'CGO_CFLAGS       $(CGO_CFLAGS)'
	@echo 'LD_LIBRARY_PATH  $(LD_LIBRARY_PATH)'
	@echo 'C_INCLUDE_PATH   $(C_INCLUDE_PATH)'
	@echo 'PKG_CONFIG_PATH  $(PKG_CONFIG_PATH)'
	@echo 'PATH             $(PATH)'

	@echo '---------------------------------------------------------'
	@echo ''


####################################################################################################################
##
## help for each task - https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
##
####################################################################################################################
.PHONY: help 

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help



####################################################################################################################
##
## Build of binaries
##
####################################################################################################################

binaries: cgo-simple-example ## build binaries in bin dir

build_app:
	go build -o ./$(BIN_NAME) -a -ldflags '$(COMPILE_LDFLAGS)' $(APP_PATH)

cgo-simple-example: build_info ## build broadcastclient binary in bin dir
	gcc -c api.c
	make BIN_NAME=cgo-simple-example APP_PATH=github.com/alexj212/cgo-simple-example build_app



####################################################################################################################
##
## Cleanup of binaries
##
####################################################################################################################

clean_binaries: clean_cgo-simple-example  ## clean all binaries in bin dir

clean_cgo-simple-example: ## clean cgo-simple-example binary
	rm -f ./api.o
	rm -f ./cgo-simple-example




####################################################################################################################
##
## Running of binaries
##
####################################################################################################################
run: ## run cgo-simple-example binary
	./cgo-simple-example

