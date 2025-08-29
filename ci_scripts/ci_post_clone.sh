#!/bin/bash

set -e

echo "Current directory: $(pwd)"
echo "Environment variables:"
env

# Install screenshotbot recorder
curl https://screenshotbot.io/recorder.sh | sh

# Update commit graph for better git performance
~/screenshotbot/recorder ci upload-commit-graph --main-branch main
