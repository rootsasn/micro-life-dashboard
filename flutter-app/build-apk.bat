@echo off
REM Micro Life Dashboard - APK Build Script (Windows)
REM Optimized for low-end Android devices

echo Building Micro Life Dashboard APK...
echo.

REM Clean previous builds
echo Cleaning previous builds...
call flutter clean
call flutter pub get

REM Generate Hive adapters if needed
echo Generating Hive adapters...
call flutter pub run build_runner build --delete-conflicting-outputs

REM Run tests
echo Running tests...
call flutter test

REM Build APK (release mode, optimized)
echo Building release APK...
call flutter build apk --release --target-platform android-arm,android-arm64 --split-per-abi --obfuscate --split-debug-info=build/app/outputs/symbols

echo.
echo Build complete!
echo.
echo APK files generated:
echo    - build\app\outputs\flutter-apk\app-armeabi-v7a-release.apk (32-bit)
echo    - build\app\outputs\flutter-apk\app-arm64-v8a-release.apk (64-bit)
echo.
echo Optimized for:
echo    - Low-end Android devices (API 21+)
echo    - Minimal storage (^< 10MB per APK)
echo    - Offline-first operation
echo    - No permissions required
echo.
echo Install command:
echo    adb install build\app\outputs\flutter-apk\app-arm64-v8a-release.apk

pause
