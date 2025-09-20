#!/bin/bash
# Version helper script for QEMU WebAssembly builds
# Generates appropriate version tags based on QEMU base version and build context
# Copyright (c) 2025 Superstruct Ltd, New Zealand
# Licensed under the same license as the underlying QEMU project (GNU GPL v2)

set -e

# Get the latest QEMU version tag
QEMU_VERSION=$(git describe --tags --abbrev=0 --match="v*" 2>/dev/null || echo "v10.1.0")
QEMU_VERSION_CLEAN=${QEMU_VERSION#v}  # Remove 'v' prefix

# Count commits since the QEMU release
COMMITS_SINCE=$(git rev-list --count ${QEMU_VERSION}..HEAD 2>/dev/null || echo "255")

# Get short commit hash
SHORT_SHA=$(git rev-parse --short HEAD)

# Determine version based on context
case "${1:-auto}" in
    "release")
        # For official releases: wasm-{qemu-version}.{build-number}
        echo "wasm-${QEMU_VERSION_CLEAN}.1"
        ;;
    "development"|"dev")
        # For development builds: wasm-dev-{qemu-version}-{commits}-{sha}
        echo "wasm-dev-${QEMU_VERSION_CLEAN}-${COMMITS_SINCE}-g${SHORT_SHA}"
        ;;
    "tag")
        # For tagged releases: use existing tag if it starts with wasm-, otherwise generate
        CURRENT_TAG=$(git describe --exact-match --tags HEAD 2>/dev/null || echo "")
        if [[ "$CURRENT_TAG" == wasm-* ]]; then
            echo "$CURRENT_TAG"
        else
            echo "wasm-${QEMU_VERSION_CLEAN}.1"
        fi
        ;;
    "auto"|*)
        # Auto-detect based on git state
        if git describe --exact-match --tags HEAD >/dev/null 2>&1; then
            # We're on a tag
            CURRENT_TAG=$(git describe --exact-match --tags HEAD)
            if [[ "$CURRENT_TAG" == wasm-* ]]; then
                echo "$CURRENT_TAG"
            else
                echo "wasm-${QEMU_VERSION_CLEAN}.1"
            fi
        else
            # Development build
            echo "wasm-dev-${QEMU_VERSION_CLEAN}-${COMMITS_SINCE}-g${SHORT_SHA}"
        fi
        ;;
esac

# Output additional metadata
echo "# Build metadata:" >&2
echo "QEMU_BASE_VERSION=${QEMU_VERSION}" >&2
echo "COMMITS_SINCE_RELEASE=${COMMITS_SINCE}" >&2 
echo "BUILD_SHA=${SHORT_SHA}" >&2
echo "BUILD_DATE=$(date -u +%Y%m%d)" >&2