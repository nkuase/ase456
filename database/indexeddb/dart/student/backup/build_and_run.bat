@echo off
REM Simple build script for Student Management System

if "%1"=="build" goto build
if "%1"=="clean" goto clean
if "%1"=="help" goto help

:dev
echo Starting development server with modern Dart APIs...
call dart pub get
call dart run build_runner clean 2>nul
echo Starting on http://localhost:8080
echo Using package:web and idb_shim (modern, non-deprecated)
call dart run build_runner serve web:8080
goto end

:build
echo Building for production...
call dart pub get
call dart pub global activate webdev
call dart pub global run webdev build --release
echo Build completed in build/ directory
goto end

:clean
echo Cleaning build artifacts...
call dart run build_runner clean 2>nul
if exist "build" rmdir /s /q "build"
echo Clean completed
goto end

:help
echo Usage: build_and_run.bat [command]
echo.
echo Commands:
echo   (none) - Start development server
echo   build  - Build for production
echo   clean  - Clean build artifacts  
echo   help   - Show this help
goto end

:end
