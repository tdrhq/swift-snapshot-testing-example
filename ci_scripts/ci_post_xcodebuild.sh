#!/bin/bash

set -e


curl https://screenshotbot.io/recorder.sh | sh
~/screenshotbot/recorder --xcresult $CI_RESULT_BUNDLE_PATH --channel swift-snapshot-testing-example-xcode-cloud
