# NB: We can't rely on `XCTExpectFailure` because it doesn't exist in `swift-corelibs-foundation`
PASS = \033[1;7;32m PASS \033[0m
FAIL = \033[1;7;31m FAIL \033[0m
XCT_FAIL = \033[34mXCTFail\033[0m
EXPECTED_STRING = This is expected to fail!
EXPECTED = \033[31m\"$(EXPECTED_STRING)\"\033[0m

test-debug:
	@swift build --build-tests \
		&& TEST_FAILURE=true swift test 2>&1 | grep '$(EXPECTED_STRING)' > /dev/null \
		&& (echo "$(PASS) $(XCT_FAIL) was called with $(EXPECTED)" && exit) \
		|| (echo "$(FAIL) expected $(XCT_FAIL) to be called with $(EXPECTED)" >&2 && exit 1)

test: test-debug
	@swift test -c release

test-linux: test-debug
	@swift test -c release

test-linux-docker:
	@docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.6.2-focal \
		bash -c "apt-get update && apt-get install make && make test"

test-linux-static-stdlib:
	@docker run \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.6.2-focal \
		bash -c "swift build -c debug -Xswiftc -static-stdlib"
	@docker run \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.6.2-focal \
		bash -c "swift build -c release -Xswiftc -static-stdlib"

format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.
