.PHONY: help
DOCKERCOMPOSE := $(shell docker compose version >/dev/null 2>&1; if [ $$? -eq 0 ]; then echo "docker compose"; else echo "docker-compose"; fi)

TMP_CONTAINER_NAME := tmp_container

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BLACK        := $(shell tput -Txterm setaf 0)
	RED          := $(shell tput -Txterm setaf 1)
	GREEN        := $(shell tput -Txterm setaf 2)
	YELLOW       := $(shell tput -Txterm setaf 3)
	LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
	PURPLE       := $(shell tput -Txterm setaf 5)
	BLUE         := $(shell tput -Txterm setaf 6)
	WHITE        := $(shell tput -Txterm setaf 7)
	RESET := $(shell tput -Txterm sgr0)
else
	BLACK        := ""
	RED          := ""
	GREEN        := ""
	YELLOW       := ""
	LIGHTPURPLE  := ""
	PURPLE       := ""
	BLUE         := ""
	WHITE        := ""
	RESET        := ""
endif

## Server
up: ## docker compose up
	$(DOCKERCOMPOSE) up
up-d: ## docker compose up -d
	$(DOCKERCOMPOSE) up -d
stop: ## docker compose stop
	$(DOCKERCOMPOSE) stop
down: ## docker compose down
	$(DOCKERCOMPOSE) down

## pt-query-digest
pt-run: ## 
	sudo pt-query-digest /var/log/mysql/mysql-slow.log > ./tmp/$(shell date +mysql-slow.log-%m-%d-%H-%M -d "+9 hours")
	ls -d ./tmp/* | tail -n1 | xargs less
pt-show: ## show latest pt
	ls -d ./tmp/* | tail -n1 | xargs less
rm-log: ## remove mysql-slow.log
	sudo rm -rf /var/log/mysql/mysql-slow.log
	sudo systemctl restart mysql
## Help:
help: ## Show this help.
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = "## "} { \
		if (/^[a-zA-Z_-]+:.*?##.*$$/) {printf "    ${YELLOW}%-30s${GREEN}%s${RESET}\n", substr($$1, 1, length($$1)-2), $$2} \
		else if (/^## .*$$/) {printf "  ${LIGHTPURPLE}%s${RESET}\n", $$2} \
		}' $(MAKEFILE_LIST)
		
