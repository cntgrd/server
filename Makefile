#
# Makefile
# Centigrade
#
# Created by Andy Rash on 2017-11-09.
#

DOCKER_ROOT = config/
SRC = Centigrade/com.cntgrd.server/

#################################
# Deployment                    #
#################################

deploy_clean:
	docker stack rm centigrade
	docker stack rm dev_centigrade
	docker stack rm testing_centigrade

deploy_dev:
	docker stack deploy --compose-file \
		./$(DOCKER_ROOT)dev/docker-compose.yml dev_centigrade

deploy_production:
	docker stack deploy --compose-file \
		./$(DOCKER_ROOT)prod/docker-compose.yml centigrade

deploy_testing:
	docker stack deploy --compose-file \
		./$(DOCKER_ROOT)testing/docker-compose.yml testing_centigrade

#################################
# Targets                       #
#################################

debug:
	$(MAKE) -C $(SRC) debug

release:
	$(MAKE) -C $(SRC) release

#################################
# Testing                       #
#################################

test:
	$(MAKE) -C $(SRC) test

#################################
# Miscellaneous                 #
#################################

clean:
	$(MAKE) -C $(SRC) clean

run_debug:
	$(MAKE) -C $(SRC) run_debug

run_release:
	$(MAKE) -C $(SRC) run_release

.PHONY: clean debug deploy_clean deploy_dev deploy_production \
		deploy_testing release run_debug run_release test
