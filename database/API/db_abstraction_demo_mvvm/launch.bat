@echo off
REM Database Abstraction Demo - Launch Script for Windows

echo 🎓 Database Abstraction Demo - Setup & Launch
echo ==============================================

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Flutter is not installed or not in PATH
    echo    Please install Flutter from https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Check Flutter doctor
echo 📋 Checking Flutter installation...
flutter doctor

REM Install dependencies
echo.
echo 📦 Installing dependencies...
flutter pub get

REM Check for any analysis issues
echo.
echo 🔍 Checking code analysis...
flutter analyze

REM Run tests
echo.
echo 🧪 Running tests...
flutter test

echo.
echo 🎉 Setup complete! You can now run the app with:
echo.
echo    For web (IndexedDB + PocketBase):
echo    flutter run -d chrome
echo.
echo    For mobile/desktop (SQLite + PocketBase):
echo    flutter run
echo.
echo 📚 Learning Resources:
echo    README.md       - Project overview
echo    QUICKSTART.md   - Quick setup guide
echo    CONCEPTS.md     - Detailed technical concepts
echo    INSTRUCTOR_GUIDE.md - Teaching guide
echo.
echo 💡 Happy learning! 🎓
pause
