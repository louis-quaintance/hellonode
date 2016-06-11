APP_IMAGE_TAG ?= v1
APP_IMAGE_NAME ?= kubernetestest-1338/hello-node
APP_IMAGE_NAME := gcr.io/${APP_IMAGE_NAME}:${APP_IMAGE_TAG}

DOCKER ?= docker
NODE_ENV ?= development
DOCKER_COMPOSE ?= docker-compose
DOCKER_RUN ?= ${DOCKER_COMPOSE} run --rm
DOCKER_BASE_IMAGE ?= node
NPM ?= ${DOCKER_RUN} -e NODE_ENV=${NODE_ENV} ${DOCKER_BASE_IMAGE} npm

PORT ?= 8080

### Helpers
all: build

tinker:
	@${DOCKER_RUN} ${DOCKER_BASE_IMAGE} /bin/bash
.PHONY: all tinker

#install
depend:
	${NPM} install
.PHONY: depend

#clean
clean-docker:
	${DOCKER} rm -fv $$(${DOCKER} ps -aq) 2> /dev/null || exit 0
.PHONY: clean-docker

test:
	${NPM} test
.PHONY: test

build:
	${DOCKER} build -t ${APP_IMAGE_NAME} .
.PHONY: build

run:
	${DOCKER} run -d -p ${PORT}:${PORT} ${APP_IMAGE_NAME}
.PHONY: run

deploy: build
	gcloud ${DOCKER} push ${APP_IMAGE_NAME}
.PHONY: deploy
