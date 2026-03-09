# Micro Life Dashboard - Flutter

## Setup

1. Install Flutter 3.19+
2. Run `flutter pub get`
3. Generate Hive adapters (if needed): `flutter pub run build_runner build`
4. Run: `flutter run`

## Features

- Offline-first with Hive local storage
- 5 max tasks with checkboxes
- 5 max notes with dates
- 2 max reminders with timeframes
- Clean, minimal UI optimized for low-end devices

## Build

- Android: `flutter build apk --release`
- iOS: `flutter build ios --release`
