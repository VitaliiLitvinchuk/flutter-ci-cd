#!/bin/bash

# Automated version increment script
# Increments the build number in pubspec.yaml

set -e

PUBSPEC_FILE="pubspec.yaml"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if pubspec.yaml exists
if [ ! -f "$PUBSPEC_FILE" ]; then
  echo "❌ pubspec.yaml not found!"
  exit 1
fi

# Read current version from pubspec.yaml
CURRENT_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | awk '{print $2}')

if [ -z "$CURRENT_VERSION" ]; then
  echo "❌ Could not find version in pubspec.yaml"
  exit 1
fi

# Split version and build number
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

# Increment build number
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
NEW_VERSION="${VERSION_NAME}+${NEW_BUILD_NUMBER}"

# Update pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  sed -i '' "s/version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "$PUBSPEC_FILE"
else
  # Linux
  sed -i "s/version: ${CURRENT_VERSION}/version: ${NEW_VERSION}/" "$PUBSPEC_FILE"
fi

echo ""
echo "================================"
echo "    Version Updated"
echo "================================"
echo -e "Old version: ${YELLOW}${CURRENT_VERSION}${NC}"
echo -e "New version: ${GREEN}${NEW_VERSION}${NC}"
echo "================================"
echo ""

# Output new version for CI/CD systems
echo "NEW_VERSION=${NEW_VERSION}" >> "$GITHUB_OUTPUT" 2>/dev/null || true
echo "VERSION_NAME=${VERSION_NAME}" >> "$GITHUB_OUTPUT" 2>/dev/null || true
echo "BUILD_NUMBER=${NEW_BUILD_NUMBER}" >> "$GITHUB_OUTPUT" 2>/dev/null || true
