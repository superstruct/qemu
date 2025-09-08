# QEMU WebAssembly Versioning Strategy

**Copyright (c) 2025 Superstruct Ltd, New Zealand**  
Licensed under the same license as the underlying QEMU project (GNU GPL v2)

## Current QEMU State
- **Latest Official Release**: `v10.1.0` (August 26, 2025)
- **Current Branch**: `master` (255 commits ahead of v10.1.0)
- **Base Commit**: `bba6f3ddf9eb6e84bcfe7b3b5a09fcfc53779f1f`

## Versioning Scheme

### Format: `wasm-{qemu-version}.{build-number}`

This format clearly distinguishes our WebAssembly builds from official QEMU releases while maintaining traceability to the base QEMU version.

### Version Types

#### 1. Release Builds
**Format**: `wasm-{qemu-version}.{build-number}`
- `wasm-10.1.0.1` - First WebAssembly build based on QEMU v10.1.0
- `wasm-10.1.0.2` - Second build with WASM improvements/fixes
- `wasm-10.2.0.1` - First build when QEMU v10.2.0 is released

#### 2. Development Builds
**Format**: `wasm-dev-{qemu-version}-{commits}-g{sha}`
- `wasm-dev-10.1.0-255-gbba6f3ddf9` - Dev build, 255 commits since v10.1.0
- `wasm-dev-10.1.0-300-gef12345678` - Later dev build with more commits

#### 3. Feature Branches
**Format**: `wasm-{feature}-{qemu-version}.{build}`
- `wasm-threading-10.1.0.1` - Threading improvements
- `wasm-performance-10.1.0.2` - Performance optimizations

## GitHub Release Strategy

### Automatic Releases
Triggered by pushing tags matching the pattern:

```bash
# Release build
git tag wasm-10.1.0.1
git push origin wasm-10.1.0.1

# Feature release  
git tag wasm-threading-10.1.0.1
git push origin wasm-threading-10.1.0.1
```

### Development Snapshots
Weekly automated snapshots from `master`:
- Tag: `wasm-dev-{date}` (e.g., `wasm-dev-20250902`)
- Retention: 30 days
- Purpose: Testing and integration

## Version Helper Usage

### In CI/CD Pipelines
```bash
# Get appropriate version for current context
VERSION=$(./github/version-helper.sh auto)
echo "Building version: $VERSION"

# For manual releases
VERSION=$(./github/version-helper.sh release)
echo "Release version: $VERSION"

# For development builds
VERSION=$(./github/version-helper.sh dev)
echo "Development version: $VERSION"
```

### Manual Version Creation
```bash
# Create a release tag
./github/version-helper.sh release
# Output: wasm-10.1.0.1

# Tag and push
git tag wasm-10.1.0.1
git push origin wasm-10.1.0.1
```

## Release Artifacts Naming

### Archive Names
- `qemu-wasm-{version}-utilities.tar.gz`
- `qemu-wasm-{version}-system-emulators.tar.gz` 
- `qemu-wasm-{version}-full.tar.gz`

### Examples
- `qemu-wasm-10.1.0.1-utilities.tar.gz`
- `qemu-wasm-dev-10.1.0-255-gbba6f3ddf9-full.tar.gz`

## Compatibility Matrix

| QEMU Base | WebAssembly Build | Emscripten | Status |
|-----------|-------------------|------------|---------|
| v10.1.0   | wasm-10.1.0.1     | 4.0.13     | ✅ Stable |
| v10.1.0   | wasm-dev-*        | 4.0.13     | 🧪 Testing |
| v10.2.0   | wasm-10.2.0.1     | 4.0.13+    | 🚧 Future |

## Version Comparison Examples

```bash
# Official QEMU versions
v10.0.0, v10.1.0, v10.2.0

# Our WebAssembly versions
wasm-10.0.0.1, wasm-10.0.0.2
wasm-10.1.0.1, wasm-10.1.0.2, wasm-10.1.0.3
wasm-dev-10.1.0-100-g1234567

# Clear distinction - no confusion with official releases
```

## Migration Path

### From Development to Release
```bash
# Development
wasm-dev-10.1.0-255-gbba6f3ddf9

# Stabilize and release
wasm-10.1.0.1

# Bug fixes
wasm-10.1.0.2
```

### QEMU Version Updates
```bash
# Current
wasm-10.1.0.3 (latest on QEMU v10.1.0)

# When QEMU v10.2.0 releases
wasm-10.2.0.1 (first build on QEMU v10.2.0)
```

## Best Practices

### For Maintainers
1. **Always tag releases** with proper wasm- prefix
2. **Use version helper** for consistent formatting  
3. **Document QEMU base** in release notes
4. **Increment build number** for fixes on same QEMU base

### For Users
1. **Check QEMU base version** for compatibility
2. **Use stable releases** (wasm-X.Y.Z.N) for production
3. **Test with dev builds** (wasm-dev-*) for early access
4. **Verify checksums** from official releases

This versioning strategy ensures clear separation from official QEMU releases while maintaining full traceability and semantic meaning.