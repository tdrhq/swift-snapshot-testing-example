# Xcode Cloud Setup Guide for Screenshotbot Integration

This guide explains how to set up Xcode Cloud to work with Screenshotbot alongside the existing CircleCI configuration.

## Overview

The project now supports both CircleCI and Xcode Cloud workflows:
- **CircleCI**: Uses `screenshotbot_ci` lane (includes running tests + screenshotbot upload)
- **Xcode Cloud**: Uses `screenshotbot_xcode_cloud` lane (screenshotbot upload only, tests run by Xcode Cloud)

## Files Added/Modified

### New Files
- `ci_scripts/ci_post_xcodebuild.sh` - Xcode Cloud post-build script that uploads snapshots to Screenshotbot

### Modified Files
- `fastlane/Fastfile` - Added Xcode Cloud specific lane and conditional CircleCI setup

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
2. **After tests complete**, the `ci_post_xcodebuild.sh` script executes:
   - Installs Ruby dependencies via Bundler
   - Downloads the Screenshotbot recorder tool
   - Uploads all snapshots from `__Snapshots__` directories to Screenshotbot

## Key Differences from CircleCI

| Aspect | CircleCI | Xcode Cloud |
|--------|----------|-------------|
| Test Execution | Handled by `tests` lane in Fastlane | Handled by Xcode Cloud workflow |
| Screenshotbot Upload | `screenshotbot_ci` lane | `screenshotbot_xcode_cloud` lane |
| Setup | Uses `setup_circle_ci` | Skips CircleCI setup |
| Environment | Custom macOS configuration | Managed by Apple |

## Troubleshooting

### Script Not Executing
- Ensure `ci_scripts/ci_post_xcodebuild.sh` has executable permissions
- Verify the file is in the correct location relative to your `.xcodeproj` file
- Check Xcode Cloud build logs for script execution errors

### Screenshotbot Upload Fails
- Verify environment variables are correctly set in Xcode Cloud
- Check that API credentials are marked as "secret" in the workflow
- Ensure the Screenshotbot recorder downloads successfully

### Bundle Install Issues
- The script includes `bundle install` to ensure Ruby dependencies are available
- If you encounter gem installation issues, you may need to add a `ci_pre_xcodebuild.sh` script

## Maintaining Both Systems

The configuration allows you to run both CircleCI and Xcode Cloud simultaneously:
- CircleCI will continue to work as before using the `screenshotbot_ci` lane
- Xcode Cloud uses the new `screenshotbot_xcode_cloud` lane
- The `setup_circle_ci` call is conditional and only runs on CircleCI

This ensures no conflicts between the two CI systems while maintaining full functionality on both platforms.