#
# Makefile
# Centigrade
#
# Created by Andy Rash on 2017-11-09.
#

DOCKER_ROOT = config/
DOCKER_COMPOSE_FILE = $(DOCKER_ROOT)docker-compose.yml
ROOT = $(shell pwd)/
SRC = Centigrade/com.cntgrd.server/
BUILD = $(SRC).build/

#################################
# Deployment                    #
#################################

deploy_dev:
	BUILD_TYPE=debug docker-compose --file $(DOCKER_COMPOSE_FILE) up -d --force-recreate

deploy_production:
	BUILD_TYPE=release docker-compose --file $(DOCKER_COMPOSE_FILE) up -d --force-recreate

stop:
	docker-compose --file $(DOCKER_COMPOSE_FILE) stop

test:
	BUILD_TYPE=debug docker-compose --file $(DOCKER_COMPOSE_FILE) run test

#################################
# Docker guest commands         #
#################################

ifeq ($(DOCKER_GUEST), true)
__debug:
	swift build --package-path $(SRC) --configuration debug 2>&1 | tee /var/log/cntgrd/build-debug.log

__release:
	swift build --package-path $(SRC) --configuration release 2>&1 | tee /var/log/cntgrd/build-release.log

__update:
	swift --version

__run_debug: __debug
	./$(BUILD)debug/com.cntgrd.server

__run_release: __release
	./$(BUILD)release/com.cntgrd.server

__test: __debug
	swift test --package-path $(SRC) 2>&1 | tee /var/log/cntgrd/test.log

endif

#################################
# Miscellaneous                 #
#################################

clean:
	rm -rf ./$(BUILD)

.PHONY: __debug __release __run_debug __run_release __test __update clean \
	deploy_dev deploy_production

