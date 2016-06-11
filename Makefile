APP_IMAGE_TAG ?= v1
APP_IMAGE_NAME ?= kubernetestest-1338/hello-node
APP_IMAGE_NAME := gcr.io/${APP_IMAGE_NAME}:${APP_IMAGE_TAG}

DOCKER ?= docker
NODE_ENV ?= development
DOCKER_COMPOSE ?= docker-compose
DOCKER_RUN ?= ${DOCKER_COMPOSE} run --rm
DOCKER_BASE_IMAGE ?= node
NPM ?= ${DOCKER_RUN} -e NODE_ENV=${NODE_ENV} ${DOCKER_BASE_IMAGE} npm

DEPLOYMENT_NAME ?= hello-node
CLUSTER_NAME ?= hello-world

PORT ?= 8080

init-docker:
	bash -c "clear && DOCKER_HOST=tcp://192.168.99.100:2376 DOCKER_CERT_PATH=/Users/lquaintance/.docker/machine/machines/default DOCKER_TLS_VERIFY=1 /bin/bash"
.PHONY: init-docker

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

deploy:
	gcloud ${DOCKER} push ${APP_IMAGE_NAME}
.PHONY: deploy

use-cluster:
	gcloud container clusters get-credentials ${CLUSTER_NAME}
.PHONY: use-cluster

create-pod:
	kubectl run ${DEPLOYMENT_NAME} --image=${APP_IMAGE_NAME} --port=8080
.PHONY: create-pod

deployments:
	kubectl get deployments
.PHONY: deployments

pods:
	kubectl get pods
.PHONY: pods

services:
	kubectl get services ${DEPLOYMENT_NAME}
.PHONY: services

expose:
	kubectl expose deployment ${DEPLOYMENT_NAME} --type="LoadBalancer"
.PHONY: expose

edit-deployment:
	kubectl edit deployment ${DEPLOYMENT_NAME}
.PHONY: edit-deployment

trigger-deployment-update:
	deployment ${DEPLOYMENT_NAME} edited
.PHONY: trigger-deployment-update

delete-deployment:
	kubectl delete service,deployment ${DEPLOYMENT_NAME}
.PHONY: delete-deployment

delete-cluster:
	gcloud container clusters delete ${CLUSTER_NAME}
.PHONY: delete-cluster

#kubectl logs <POD-NAME>
#kubectl cluster-info
#kubectl get events
#kubectl config view
