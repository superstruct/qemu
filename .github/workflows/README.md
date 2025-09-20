# QEMU WebAssembly CI/CD Workflows

**Copyright (c) 2025 Superstruct Ltd, New Zealand**  
Licensed under the same license as the underlying QEMU project (GNU GPL v2)

This directory contains GitHub Actions workflows for building and releasing QEMU WebAssembly binaries.

## Workflows

### 1. `wasm-build.yml` - Main Build & Release
**Triggers:** 
- Push to `master` or `wasm-*` branches
- Tags matching `v*` or `wasm-*`
- Pull requests to `master`
- Manual dispatch with release option

**Features:**
- Matrix build (utilities + system emulators)
- Comprehensive dependency caching
- Automated releases for tags
- Full artifact packaging

**Outputs:**
- `qemu-wasm-utilities.tar.gz` - All QEMU utilities (img, io, nbd, edid)
- `qemu-wasm-system-emulators.tar.gz` - System emulators (i386, arm)
- `qemu-wasm-full.tar.gz` - Combined package
- `checksums.txt` - SHA256 checksums

### 2. `wasm-quick.yml` - Development Build
**Triggers:** Manual dispatch only

**Features:**
- Faster builds for development/testing
- Selectable build targets (utilities/system/both)
- Optional cache bypass
- Shorter artifact retention (7 days)

**Usage:**
1. Go to Actions tab in your GitHub repo
2. Select "QEMU WASM Quick Build"
3. Click "Run workflow"
4. Choose build target and options

## Build Matrix

| Target | Configure Args | Outputs | Size |
|--------|---------------|---------|------|
| utilities | `--disable-system --disable-user --enable-tools` | qemu-img, qemu-io, qemu-nbd, qemu-edid | ~16MB |
| system-emulators | `--disable-user --disable-tools --enable-system --target-list=i386-softmmu,arm-softmmu` | qemu-system-i386, qemu-system-arm | ~72MB |

## Caching Strategy

1. **Emscripten SDK** - Cached by version
2. **WASM Dependencies** - Cached by cross.meson hash
3. **Build Artifacts** - 30 days (main), 7 days (quick)

## Release Process

### Automatic (Tags)
```bash
git tag wasm-v1.0.0
git push origin wasm-v1.0.0
```

### Manual
1. Go to Actions → "QEMU WebAssembly Build"
2. Click "Run workflow" 
3. Check "Create GitHub release"
4. Artifacts will be packaged and released

## Dependencies Built

All dependencies are cross-compiled for WebAssembly:

1. **zlib 1.3.1** - Compression library
2. **libffi 3.4.7** - Foreign function interface  
3. **pixman 0.44.2** - Pixel manipulation
4. **glib 2.84.0** - Core utilities (with pthread patches)
5. **libresolv stub** - Resolver functions stub

## Build Configuration

### Common Flags
- `--with-coroutine=wasm` - WebAssembly coroutine backend
- `--enable-tcg-interpreter` - Required for WASM host
- `--cc=emcc --cxx=em++ --ar=emar --ranlib=emranlib` - Emscripten toolchain

### Disabled Features (for WASM compatibility)
- KVM, Xen virtualization
- VNC, GTK, SDL graphics
- curl, libssh networking
- PNG, JPEG image formats
- zstd compression

## Troubleshooting

### Build Failures
1. Check dependency cache - may need invalidation
2. Verify Emscripten version compatibility
3. Check cross.meson configuration

### Missing Artifacts
1. Ensure build targets completed successfully
2. Check artifact upload step logs
3. Verify file paths in build output

### Release Issues
1. Confirm tag format (`v*` or `wasm-*`)
2. Check GitHub token permissions
3. Verify release step configuration

## Local Testing

To test the workflow locally:

```bash
# Install act (GitHub Actions runner)
gh extension install https://github.com/nektos/gh-act

# Run workflow locally  
gh act workflow_dispatch -W .github/workflows/wasm-quick.yml
```
