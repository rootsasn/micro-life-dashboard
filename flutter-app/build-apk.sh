#!/bin/bash

# Micro Life Dashboard - APK Build Script
# Optimized for low-end Android devices

set -e

echo "🚀 Building Micro Life Dashboard APK..."
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Generate Hive adapters if needed
echo "🔧 Generating Hive adapters..."
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
echo "🧪 Running tests..."
flutter test

# Build APK (release mode, optimized)
echo "📦 Building release APK..."
flutter build apk --release \
  --target-platform android-arm,android-arm64 \
  --split-per-abi \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

echo ""
echo "✅ Build complete!"
echo ""
echo "📱 APK files generated:"
echo "   - build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk (32-bit)"
echo "   - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk (64-bit)"
echo ""
echo "📊 APK sizes:"
ls -lh build/app/outputs/flutter-apk/*.apk | awk '{print "   " $9 ": " $5}'
echo ""
echo "🎯 Optimized for:"
echo "   - Low-end Android devices (API 21+)"
echo "   - Minimal storage (< 10MB per APK)"
echo "   - Offline-first operation"
echo "   - No permissions required"
echo ""
echo "📲 Install command:"
echo "   adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"
