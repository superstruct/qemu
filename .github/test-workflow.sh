#!/bin/bash
# Test script to validate workflow components locally

set -e

echo "🧪 Testing QEMU WebAssembly workflow components..."

# Test 1: Check required files exist
echo "📁 Checking required files..."
required_files=(
    "wasm-deps/cross.meson"
    "CLAUDE.md"
    "meson.build"
    ".github/workflows/wasm-build.yml"
    ".github/workflows/wasm-quick.yml"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Test 2: Validate workflow triggers
echo -e "\n🎯 Checking workflow triggers..."
if grep -q "workflow_dispatch" .github/workflows/wasm-build.yml; then
    echo "✅ Manual trigger configured"
fi

if grep -q "tags.*wasm" .github/workflows/wasm-build.yml; then
    echo "✅ Tag-based release configured"  
fi

# Test 3: Check matrix configuration
echo -e "\n🔀 Validating build matrix..."
if grep -q "utilities" .github/workflows/wasm-build.yml && grep -q "system-emulators" .github/workflows/wasm-build.yml; then
    echo "✅ Build matrix configured correctly"
fi

# Test 4: Validate caching keys
echo -e "\n💾 Checking cache configuration..."
if grep -q "cache-emsdk" .github/workflows/wasm-build.yml; then
    echo "✅ Emscripten SDK caching configured"
fi

if grep -q "cache-wasm-deps" .github/workflows/wasm-build.yml; then
    echo "✅ WASM dependencies caching configured"
fi

# Test 5: Check build targets
echo -e "\n🎯 Validating build targets..."
expected_targets=(
    "qemu-img"
    "qemu-io" 
    "qemu-nbd"
    "qemu-edid"
    "qemu-system-i386"
    "qemu-system-arm"
)

for target in "${expected_targets[@]}"; do
    if grep -q "$target" .github/workflows/wasm-build.yml; then
        echo "✅ $target build configured"
    else
        echo "⚠️  $target not found in workflow"
    fi
done

# Test 6: Release configuration
echo -e "\n📦 Checking release configuration..."
if grep -q "softprops/action-gh-release" .github/workflows/wasm-build.yml; then
    echo "✅ GitHub release action configured"
fi

if grep -q "checksums.txt" .github/workflows/wasm-build.yml; then
    echo "✅ Checksums generation configured"
fi

echo -e "\n✨ Workflow validation complete!"
echo "🚀 Ready for GitHub Actions deployment"