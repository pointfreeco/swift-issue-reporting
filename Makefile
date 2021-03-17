PASS = \033[1;7;32m PASS \033[0m
FAIL = \033[1;7;31m FAIL \033[0m
XCT_FAIL = \033[34mXCTFail\033[0m
EXPECTED_STRING = This is expected to fail!
EXPECTED = \033[31m\"$(EXPECTED_STRING)\"\033[0m

test:
	@swift test --enable-test-discovery 2>&1 | grep '$(EXPECTED_STRING)' > /dev/null \
		&& (echo "$(PASS) $(XCT_FAIL) was called with $(EXPECTED)" && exit) \
		|| (echo "$(FAIL) expected $(XCT_FAIL) to be called with $(EXPECTED)" >&2 && exit 1)

test-linux:
	@docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.3 \
		bash -c "make test"

format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.
