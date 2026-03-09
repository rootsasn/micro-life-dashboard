# Deployment Guide - Micro Life Dashboard

## Building APK for Android

### Prerequisites
- Flutter SDK 3.19+
- Android SDK (API 21+)
- Java JDK 8+

### Quick Build

**Linux/Mac:**
```bash
chmod +x build-apk.sh
./build-apk.sh
```

**Windows:**
```bash
build-apk.bat
```

### Manual Build

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Generate Hive adapters
flutter pub run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Build release APK (split by ABI for smaller size)
flutter build apk --release \
  --target-platform android-arm,android-arm64 \
  --split-per-abi \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

### Output Files

APKs are generated in `build/app/outputs/flutter-apk/`:
- `app-armeabi-v7a-release.apk` - 32-bit ARM (older devices)
- `app-arm64-v8a-release.apk` - 64-bit ARM (newer devices)

### APK Size Optimization

Current optimizations:
- Split APKs by ABI (~5-8MB each)
- Code obfuscation enabled
- Resource shrinking enabled
- ProGuard optimization
- No unused permissions
- Minimal dependencies

### Installation

**Via ADB:**
```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

**Via File Transfer:**
1. Copy APK to device
2. Enable "Install from Unknown Sources"
3. Tap APK file to install

## Optimization for Low-End Devices

### Target Specifications
- **RAM**: 1GB minimum
- **Storage**: 10MB app size
- **Android**: API 21+ (Android 5.0+)
- **Network**: Fully offline, no internet required

### Performance Optimizations

**Build Configuration:**
- `minSdk 21` - Wide device compatibility
- `targetSdk 34` - Latest features
- Split APKs by ABI - Smaller downloads
- ProGuard enabled - Code optimization
- Resource shrinking - Remove unused assets

**Runtime Optimizations:**
- Hive for fast local storage
- Provider for efficient state management
- Minimal animations
- Lazy loading where possible
- No heavy dependencies

**UI Optimizations:**
- Material 3 with standard density
- Simple page transitions
- Efficient list rendering
- Minimal elevation/shadows
- No complex gradients

### Testing on Low-End Devices

**Recommended Test Devices:**
- Samsung Galaxy J2 (1GB RAM)
- Xiaomi Redmi 5A (2GB RAM)
- Any device with Android 5.0+

**Performance Metrics:**
- App launch: <2s
- Screen transitions: <300ms
- Data operations: <100ms
- Memory usage: <50MB

## Distribution

### Google Play Store

1. Create signed APK:
```bash
flutter build apk --release
```

2. Upload to Play Console
3. Set minimum API level: 21
4. Target countries: Pakistan, India, etc.

### Direct Distribution

1. Host APK on website
2. Share download link
3. Users enable "Unknown Sources"
4. Install directly

### WhatsApp/Telegram Distribution

1. Compress APK if needed
2. Share via messaging apps
3. Include installation instructions
4. Provide support contact

## Offline Support

The app is fully offline:
- ✅ No internet permission required
- ✅ All data stored locally (Hive)
- ✅ No network calls
- ✅ Works in airplane mode
- ✅ No ads or tracking

## Permissions

**Required:** None

**Optional:** None

The app requires zero permissions, making it:
- Privacy-friendly
- Fast to install
- Trustworthy for users
- Compliant with regulations

## Troubleshooting

### Build Fails

```bash
# Clear Flutter cache
flutter clean
rm -rf build/

# Reset pub cache
flutter pub cache repair

# Rebuild
flutter pub get
flutter build apk --release
```

### APK Too Large

- Ensure split APKs are enabled
- Check for unused dependencies
- Verify ProGuard is working
- Remove debug symbols

### App Crashes on Low-End Devices

- Test on actual low-end hardware
- Profile memory usage
- Reduce image sizes
- Simplify animations

## Support

For issues or questions:
- Check Flutter logs: `flutter logs`
- Run diagnostics: `flutter doctor`
- Test on emulator: `flutter run`
