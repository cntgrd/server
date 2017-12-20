#
# Makefile
# Centigrade
#
# Created by Andy Rash on 2017-11-09.
#

DOCKER_ROOT = config/
ROOT = $(shell pwd)/
SRC = Centigrade/com.cntgrd.server/
BUILD = $(SRC).build/

#################################
# Deployment                    #
#################################

deploy_clean:
	docker stack rm centigrade

deploy_dev:
	docker stack deploy --compose-file \
		./$(DOCKER_ROOT)dev/docker-compose.yml centigrade

deploy_production:
	docker stack deploy --compose-file \
		./$(DOCKER_ROOT)prod/docker-compose.yml centigrade

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
	swift test --package-path $(SRC)

endif

#################################
# Miscellaneous                 #
#################################

clean:
	rm -rf ./$(BUILD)

.PHONY: clean __debug deploy_clean deploy_dev deploy_production __release \
		run_debug run_release test __update
