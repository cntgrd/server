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
	export BUILD_TYPE=debug
	docker-compose --file $(DOCKER_COMPOSE_FILE) up

deploy_production:
	export BUILD_TYPE=release
	docker-compose --file $(DOCKER_COMPOSE_FILE) up -d

stop:
	docker-compose --file $(DOCKER_COMPOSE_FILE) stop

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

run_debug: __debug
	./$(BUILD)debug/com.cntgrd.server

run_release: __release
	./$(BUILD)release/com.cntgrd.server

test: __debug
	swift test --package-path $(SRC) 2>&1 | tee /var/log/cntgrd/test.log

endif

#################################
# Miscellaneous                 #
#################################

clean:
	rm -rf ./$(BUILD)

.PHONY: clean __debug deploy_clean deploy_dev deploy_production __release \
		run_debug run_release test __update
