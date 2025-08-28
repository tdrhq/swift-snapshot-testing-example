#!/bin/bash

set -e

echo "🚀 Starting Screenshotbot upload process..."

# Check if CI_RESULT_BUNDLE_PATH is available (indicates test execution completed)
if [[ -n "$CI_RESULT_BUNDLE_PATH" && -d "$CI_RESULT_BUNDLE_PATH" ]]; then
    echo "📱 Test results detected at: $CI_RESULT_BUNDLE_PATH"
    echo "🔍 Searching for generated snapshots..."
    
    # Look for __Snapshots__ directories in various possible locations
    SNAPSHOT_DIRS=()
    
    # Search in CI_RESULT_BUNDLE_PATH (xcresult bundle may contain attachments)
    if find "$CI_RESULT_BUNDLE_PATH" -name "__Snapshots__" -type d 2>/dev/null | head -1 >/dev/null; then
        while IFS= read -r -d '' dir; do
            SNAPSHOT_DIRS+=("$dir")
        done < <(find "$CI_RESULT_BUNDLE_PATH" -name "__Snapshots__" -type d -print0 2>/dev/null)
    fi
    
    # Search in derived data path if available
    if [[ -n "$CI_DERIVED_DATA_PATH" ]]; then
        if find "$CI_DERIVED_DATA_PATH" -name "__Snapshots__" -type d 2>/dev/null | head -1 >/dev/null; then
            while IFS= read -r -d '' dir; do
                SNAPSHOT_DIRS+=("$dir")
            done < <(find "$CI_DERIVED_DATA_PATH" -name "__Snapshots__" -type d -print0 2>/dev/null)
        fi
    fi
    
    # Search in current working directory as fallback
    if find . -name "__Snapshots__" -type d 2>/dev/null | head -1 >/dev/null; then
        while IFS= read -r -d '' dir; do
            SNAPSHOT_DIRS+=("$dir")
        done < <(find . -name "__Snapshots__" -type d -print0 2>/dev/null)
    fi
    
    if [ ${#SNAPSHOT_DIRS[@]} -gt 0 ]; then
        echo "📸 Found ${#SNAPSHOT_DIRS[@]} snapshot directories:"
        for dir in "${SNAPSHOT_DIRS[@]}"; do
            echo "  - $dir"
        done
        
        # Install bundler dependencies without sudo
        echo "📦 Installing Ruby dependencies..."
        bundle install --path vendor/bundle --deployment || bundle install --path vendor/bundle
        
        # Fetch screenshotbot
        echo "⬇️ Fetching Screenshotbot recorder..."
        bundle exec fastlane fetch_screenshotbot
        
        # Upload snapshots to Screenshotbot
        echo "🔄 Uploading snapshots to Screenshotbot..."
        for dir in "${SNAPSHOT_DIRS[@]}"; do
            # Extract channel name from directory path
            channel_name=$(echo "$dir" | sed 's|.*/\([^/]*\)/__Snapshots__.*|\1|')
            echo "  📤 Uploading $dir as channel: $channel_name"
            ~/screenshotbot/recorder --channel "$channel_name" --directory "$dir" --recursive
        done
        
        echo "✅ Screenshotbot upload completed successfully!"
    else
        echo "⚠️ No __Snapshots__ directories found - tests may not have generated snapshots"
        echo "🔍 Debug info:"
        echo "  CI_RESULT_BUNDLE_PATH: $CI_RESULT_BUNDLE_PATH"
        echo "  CI_DERIVED_DATA_PATH: $CI_DERIVED_DATA_PATH"
        echo "  Current directory: $(pwd)"
        ls -la || echo "Cannot list current directory"
    fi
else
    echo "ℹ️ Skipping Screenshotbot upload - CI_RESULT_BUNDLE_PATH not available (not a test execution)"
    echo "🔍 Debug info:"
    echo "  CI_RESULT_BUNDLE_PATH: $CI_RESULT_BUNDLE_PATH"
    echo "  CI_ARCHIVE_PATH: $CI_ARCHIVE_PATH"
    echo "  Current directory: $(pwd)"
fi

echo "🏁 ci_post_xcodebuild.sh completed"