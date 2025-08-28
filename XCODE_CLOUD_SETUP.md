# Xcode Cloud Setup Guide for Screenshotbot Integration

This guide explains how to set up Xcode Cloud to work with Screenshotbot alongside the existing CircleCI configuration.

## Overview

The project now supports both CircleCI and Xcode Cloud workflows:
- **CircleCI**: Uses `screenshotbot_ci` lane (includes running tests + screenshotbot upload)
- **Xcode Cloud**: Uses direct Screenshotbot upload after test execution (tests run by Xcode Cloud)

## Key Differences for Runtime-Generated Snapshots

**Important**: This setup is designed for forks of swift-snapshot-testing where `__Snapshots__` directories are created during test execution, not beforehand. The solution addresses Xcode Cloud's architecture where:

1. **Build Environment**: Compiles and builds the project
2. **Test Environment**: Runs tests in a separate environment where snapshots are generated
3. **Post-Test Access**: The `ci_post_xcodebuild.sh` script can access generated snapshots via environment variables

## Files Added/Modified

### New Files
- `ci_scripts/ci_post_xcodebuild.sh` - Xcode Cloud post-test script that finds and uploads generated snapshots

### Modified Files
- `fastlane/Fastfile` - Added conditional CircleCI setup to avoid conflicts

## Xcode Cloud Setup Steps

### 1. Configure Xcode Cloud Workflow
1. Open your project in Xcode
2. Go to **Product** → **Xcode Cloud** → **Create Workflow**
3. Choose your repository and branch
4. Set up the workflow with these settings:
   - **Build Action**: Build and Test
   - **Scheme**: Select your test scheme (e.g., `SimpleProject`)
   - **Platform**: iOS
   - **Test Destination**: Choose your target devices (e.g., iPhone SE 3rd generation)

### 2. Environment Variables
Add the following environment variables in your Xcode Cloud workflow settings:
- `SCREENSHOTBOT_API_KEY` - Your Screenshotbot API key (mark as secret)
- `SCREENSHOTBOT_API_SECRET` - Your Screenshotbot API secret (mark as secret)
- Any other environment variables your Screenshotbot setup requires

### 3. Webhook Configuration (Optional)
If you need webhook notifications from Screenshotbot, configure them in your Screenshotbot dashboard.

## How It Works

1. **Xcode Cloud runs your tests** automatically using the configured scheme
2. **During test execution**, your swift-snapshot-testing fork generates `__Snapshots__` directories with test results
3. **After tests complete**, the `ci_post_xcodebuild.sh` script executes and:
   - Detects test completion via the `CI_RESULT_BUNDLE_PATH` environment variable
   - Searches for generated `__Snapshots__` directories in multiple locations:
     - XCResult bundle path (`CI_RESULT_BUNDLE_PATH`)
     - Derived data path (`CI_DERIVED_DATA_PATH`) 
     - Current working directory (fallback)
   - Installs Ruby dependencies via Bundler
   - Downloads the Screenshotbot recorder tool
   - Uploads all found snapshots to Screenshotbot with appropriate channel names

## Key Differences from CircleCI

| Aspect | CircleCI | Xcode Cloud |
|--------|----------|-------------|
| Test Execution | Handled by `tests` lane in Fastlane | Handled by Xcode Cloud workflow |
| Snapshot Generation | Pre-existing `__Snapshots__` directories | Runtime-generated during test execution |
| Screenshotbot Upload | `screenshotbot_ci` lane via Fastlane | Direct upload in `ci_post_xcodebuild.sh` |
| Snapshot Discovery | Known directory structure | Dynamic search using environment variables |
| Setup | Uses `setup_circle_ci` | Skips CircleCI setup |
| Environment | Custom macOS configuration | Managed by Apple |

## Troubleshooting

### Script Not Executing
- Ensure `ci_scripts/ci_post_xcodebuild.sh` has executable permissions: `chmod +x ci_scripts/ci_post_xcodebuild.sh`
- Verify the file is in the correct location relative to your `.xcodeproj` file
- Check Xcode Cloud build logs for script execution errors

### No Snapshots Found
- Check Xcode Cloud logs for the "Debug info" section when no snapshots are found
- Verify your swift-snapshot-testing fork is actually generating `__Snapshots__` directories during test execution
- The script searches in `CI_RESULT_BUNDLE_PATH`, `CI_DERIVED_DATA_PATH`, and current directory
- Ensure tests are actually running and generating snapshots (not just building)

### Screenshotbot Upload Fails
- Verify environment variables are correctly set in Xcode Cloud
- Check that API credentials (`SCREENSHOTBOT_API_KEY`, `SCREENSHOTBOT_API_SECRET`) are marked as "secret" 
- Ensure the Screenshotbot recorder downloads successfully
- Check the channel names extracted from directory paths are correct

### Bundle Install Issues
- The script includes `bundle install` to ensure Ruby dependencies are available
- If you encounter gem installation issues, you may need to add a `ci_pre_xcodebuild.sh` script for additional setup

### Environment Variable Issues
- `CI_RESULT_BUNDLE_PATH` is only available after test execution, not during build-only actions
- The script will only run snapshot upload when `CI_RESULT_BUNDLE_PATH` is present and valid
- Check the debug output in Xcode Cloud logs to verify environment variable values

## Maintaining Both Systems

The configuration allows you to run both CircleCI and Xcode Cloud simultaneously:
- CircleCI will continue to work as before using the `screenshotbot_ci` lane
- Xcode Cloud uses the new `screenshotbot_xcode_cloud` lane
- The `setup_circle_ci` call is conditional and only runs on CircleCI

This ensures no conflicts between the two CI systems while maintaining full functionality on both platforms.