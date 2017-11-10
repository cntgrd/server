#
# Makefile
# Centigrade
#
# Created by Andy Rash on 2017-11-09.
#

BUILD = .build/
SRC = ./

#################################
# Targets                       #
#################################

debug:
	swift build --package-path $(SRC) --configuration debug

release:
	swift build --package-path $(SRC) --configuration release

#################################
# Testing                       #
#################################

test: debug 
	swift test --package-path $(SRC) 

#################################
# Miscellaneous                 #
#################################

clean:
	rm -rf ./$(BUILD)
	rm -rf ./Package.resolved

run_debug: debug
	./.build/debug/Run serve

run_release: release
	./.build/release/Run serve

.PHONY: clean debug release run_debug run_release test
