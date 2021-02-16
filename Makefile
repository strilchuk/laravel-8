#!make
include deploy/.env
export $(shell sed 's/=.*//' ${DOCKER_DIR}/.env)
.PHONY: help docker-env nginx-config
RUN = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml run --rm
START = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml up -d
STOP = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml stop
LOGS = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml logs
EXEC = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml exec
BUILD = docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml build

build-db:
	@$(BUILD) --no-cache db-wtb

build-app:
	@$(BUILD) --no-cache app-wtb

build-nginx:
	@$(BUILD) --no-cache nginx-wtb

build: build-app build-db build-nginx

up:
	@$(START)
	@$(MAKE) --no-print-directory status

stop:
	@echo "\n\033[1;m  Stop docker... \033[0m"
	@$(STOP)
	@$(MAKE) --no-print-directory status

restart:
	@echo "\n\033[1;m Restarting docker... \033[0m"
	@$(STOP)
	@$(START)
	@$(MAKE) --no-print-directory status

status:
	@echo "\n\033[1;m Containers statuses \033[0m"
	@docker-compose -f ${DOCKER_DIR}/docker-compose-${DOCKER_ENV}.yml ps

console-app:
	@$(EXEC) app-wtb bash

console-nginx:
	@$(EXEC) nginx-wtb bash

console-db:
	@$(EXEC) db-wtb bash

logs-nginx:
	@$(LOGS)  --tail=100 -f nginx-wtb

logs-app:
	@$(LOGS)  --tail=100 -f app-wtb

logs-db:
	@$(LOGS)  --tail=100 -f db-wtb

nginx-check:
	@$(EXEC) nginx-wtb nginx -t

nginx-reload:
	@$(EXEC) nginx-wtb nginx -s reload
