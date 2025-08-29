#!/bin/bash

set -e

echo "Current directory: $(pwd)"
echo "CI_XCODEBUILD_ACTION: $CI_XCODEBUILD_ACTION"
echo "Environment variables:"
env

# Change to project root
cd ..

# Only run after successful test actions
if [[ "$CI_XCODEBUILD_ACTION" == "test-without-building" ]] && [[ -d "$CI_RESULT_BUNDLE_PATH" ]]; then
    curl https://screenshotbot.io/recorder.sh | sh
    ~/screenshotbot/recorder --xcresult $CI_RESULT_BUNDLE_PATH --channel swift-snapshot-testing-example-xcode-cloud --commit-limit 0
fi
