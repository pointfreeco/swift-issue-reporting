XCODE_PATH := $(shell xcode-select -p)

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

test-release:
	@swift test -c release

test-linux:
	docker run \
		--rm \
		-v "$(PWD):$(PWD)" \
		-w "$(PWD)" \
		swift:5.10 \
		bash -c 'swift test'

build-for-static-stdlib:
	@swift build -c debug --static-swift-stdlib
	@swift build -c release --static-swift-stdlib

format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--recursive \
		.

xcframeworks: xcframework-5-9 xcframework-6-0

xcframework-5-9:
	sudo xcode-select -s /Applications/Xcode-15.2.0.app
	rm -fr archives xcframeworks/IssueReportingTestSupport.509.xcframework
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=iOS" \
		-archivePath "archives/IssueReportingTestSupport-iOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=iOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-iOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=macOS" \
		-archivePath "archives/IssueReportingTestSupport-macOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=macOS,variant=Mac Catalyst" \
		-archivePath "archives/IssueReportingTestSupport-Mac_Catalyst" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=tvOS" \
		-archivePath "archives/IssueReportingTestSupport-tvOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=tvOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-tvOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=visionOS" \
		-archivePath "archives/IssueReportingTestSupport-visionOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=visionOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-visionOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=watchOS" \
		-archivePath "archives/IssueReportingTestSupport-watchOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=watchOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-watchOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		SKIP_INSTALL=NO
	mkdir -p xcframeworks
	xcodebuild -create-xcframework \
		-framework archives/IssueReportingTestSupport-iOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-iOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-macOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-Mac_Catalyst.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-tvOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-tvOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-visionOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-visionOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-watchOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-watchOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-output xcframeworks/IssueReportingTestSupport.509.xcframework
	sudo xcode-select -s $(XCODE_PATH)

xcframework-6-0:
	sudo xcode-select -s /Applications/Xcode-16.0.0-Beta.3.app
	rm -fr archives xcframeworks/IssueReportingTestSupport.600.xcframework
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=iOS" \
		-archivePath "archives/IssueReportingTestSupport-iOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=iOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-iOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=macOS" \
		-archivePath "archives/IssueReportingTestSupport-macOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=macOS,variant=Mac Catalyst" \
		-archivePath "archives/IssueReportingTestSupport-Mac_Catalyst" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=tvOS" \
		-archivePath "archives/IssueReportingTestSupport-tvOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=tvOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-tvOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=visionOS" \
		-archivePath "archives/IssueReportingTestSupport-visionOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=visionOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-visionOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=watchOS" \
		-archivePath "archives/IssueReportingTestSupport-watchOS" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	xcodebuild archive \
		-project TestSupport/IssueReportingTestSupport.xcodeproj \
		-scheme IssueReportingTestSupport \
		-destination "generic/platform=watchOS Simulator" \
		-archivePath "archives/IssueReportingTestSupport-watchOS_Simulator" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
		OTHER_LDFLAGS="-weak_framework Testing $$(inherited)" \
		SKIP_INSTALL=NO
	mkdir -p xcframeworks
	xcodebuild -create-xcframework \
		-framework archives/IssueReportingTestSupport-iOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-iOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-macOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-Mac_Catalyst.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-tvOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-tvOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-visionOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-visionOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-watchOS.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-framework archives/IssueReportingTestSupport-watchOS_Simulator.xcarchive/Products/Library/Frameworks/IssueReportingTestSupport.framework \
		-output xcframeworks/IssueReportingTestSupport.600.xcframework
	sudo xcode-select -s $(XCODE_PATH)
