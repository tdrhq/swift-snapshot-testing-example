#!/bin/bash

set -e

echo "🚀 Starting Screenshotbot upload process..."

# Check if this is a test action that ran successfully
if [[ "$CI_XCODE_PROJECT" != "" && "$CI_ARCHIVE_PATH" == "" ]]; then
    echo "📱 Test build detected - proceeding with snapshot upload"
    
    # Install bundler dependencies
    echo "📦 Installing Ruby dependencies..."
    bundle install
    
    # Fetch screenshotbot
    echo "⬇️ Fetching Screenshotbot recorder..."
    bundle exec fastlane fetch_screenshotbot
    
    # Upload all snapshots to Screenshotbot using Xcode Cloud specific lane
    echo "📸 Uploading snapshots to Screenshotbot..."
    bundle exec fastlane screenshotbot_xcode_cloud
    
    echo "✅ Screenshotbot upload completed successfully!"
else
    echo "ℹ️ Skipping Screenshotbot upload - not a test build or build failed"
fi

echo "🏁 ci_post_xcodebuild.sh completed"