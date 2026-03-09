# Micro Life Dashboard - Flutter

A brutally simple, offline-first mobile app for daily essentials.

## Features

- 5 max tasks with checkboxes
- 5 max notes with dates
- 2 max reminders with timeframes
- Offline-first with Hive local storage
- Material 3 design with big tappable cards
- Optimized for low-end Android devices
- Zero permissions required
- <10MB APK size

## Quick Start

### Development

```bash
flutter pub get
flutter run
```

### Build APK

**Linux/Mac:**
```bash
chmod +x build-apk.sh
./build-apk.sh
```

**Windows:**
```bash
build-apk.bat
```

### Install on Device

```bash
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

## Architecture

### Screens
- **SplashScreen**: Loading screen with branding
- **HomeScreen**: Main ListView with tasks, notes, reminders

### Providers
- **DataProvider**: State management with ChangeNotifier
- **LifecycleObserver**: App lifecycle management

### Widgets
- **ItemCard**: Reusable card for all item types
- **AddBottomSheet**: Modal for adding items
- **EmptyState**: Placeholder when sections empty

### Models
- **Task**: Text, completed, timestamp (Hive)
- **Note**: Text, date (Hive)
- **Reminder**: Text, timeframe (Hive)

## Optimization for Low-End Devices

### Target Specs
- **RAM**: 1GB minimum
- **Storage**: <10MB app size
- **Android**: API 21+ (5.0+)
- **Network**: Fully offline

### Optimizations Applied
- Split APKs by ABI (5-8MB each)
- Code obfuscation & minification
- Resource shrinking
- ProGuard optimization
- Minimal dependencies
- Efficient state management
- Fast local storage (Hive)
- Simple animations
- Standard visual density

### Performance Targets
- App launch: <2s
- Screen transitions: <300ms
- Data operations: <100ms
- Memory usage: <50MB

## Offline Support

✅ Fully offline - no internet required
✅ Zero permissions needed
✅ All data stored locally
✅ Works in airplane mode
✅ No ads or tracking

## Testing

```bash
flutter test
```

## Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed build and distribution instructions.

## License

MIT License - See LICENSE file for details
