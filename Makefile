XCODE_PATH := $(shell xcode-select -p)

# NB: We can't rely on `XCTExpectFailure` because it doesn't exist in `swift-corelibs-foundation`
PASS = \033[1;7;32m PASS \033[0m
FAIL = \033[1;7;31m FAIL \033[0m
XCT_FAIL = \033[34mXCTFail\033[0m
EXPECTED_STRING = This is expected to fail!
EXPECTED = \033[31m\"$(EXPECTED_STRING)\"\033[0m

test:
	@swift build --build-tests -c $(CONFIG) \
		&& TEST_FAILURE=true swift test -c $(CONFIG) 2>&1 | grep '$(EXPECTED_STRING)' > /dev/null \
		&& (echo "$(PASS) $(XCT_FAIL) was called with $(EXPECTED)" && exit) \
		|| (echo "$(FAIL) expected $(XCT_FAIL) to be called with $(EXPECTED)" >&2 && exit 1)

test-examples:
	xcodebuild test \
		-configuration $(CONFIG) \
	 	-workspace IssueReporting.xcworkspace \
		-scheme Examples \
		-destination platform="iOS Simulator,name=iPhone 15"

test-linux:
	docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.10 \
		bash -c 'swift test'

build-for-static-stdlib:
	@swift build -c $(CONFIG) --static-swift-stdlib

format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.
