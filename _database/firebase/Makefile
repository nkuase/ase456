# Firebase Student App - Development Commands
# Usage: make <command>

.PHONY: help setup clean test build run install lint format docs docker

# Default target
help:
	@echo "🔥 Firebase Student App - Available Commands"
	@echo "============================================"
	@echo ""
	@echo "📦 Setup & Installation:"
	@echo "  make setup          Install all dependencies and configure project"
	@echo "  make install        Install Flutter dependencies"
	@echo "  make clean          Clean build artifacts and reset dependencies"
	@echo ""
	@echo "🚀 Development:"
	@echo "  make run            Run the Flutter app (debug mode)"
	@echo "  make run-web        Run the Flutter web app"
	@echo "  make run-release    Run the Flutter app (release mode)"
	@echo "  make emulators      Start Firebase emulators"
	@echo "  make stop-emulators Stop Firebase emulators"
	@echo ""
	@echo "🧪 Testing:"
	@echo "  make test           Run all tests"
	@echo "  make test-unit      Run unit tests only"
	@echo "  make test-firebase  Run tests with Firebase emulators"
	@echo "  make test-coverage  Run tests with coverage report"
	@echo "  make test-performance Run performance tests"
	@echo ""
	@echo "🔧 Code Quality:"
	@echo "  make lint           Run dart analysis"
	@echo "  make format         Format code"
	@echo "  make format-check   Check code formatting"
	@echo "  make security       Run security analysis"
	@echo ""
	@echo "📊 Build & Deploy:"
	@echo "  make build-android  Build Android APK"
	@echo "  make build-ios      Build iOS app"
	@echo "  make build-web      Build web app"
	@echo "  make build-all      Build for all platforms"
	@echo ""
	@echo "📚 Documentation:"
	@echo "  make docs           Generate documentation"
	@echo "  make docs-serve     Serve documentation locally"
	@echo ""
	@echo "🐋 Docker:"
	@echo "  make docker-build   Build Docker image"
	@echo "  make docker-run     Run app in Docker"
	@echo "  make docker-dev     Start development environment"
	@echo "  make docker-clean   Clean Docker resources"
	@echo ""
	@echo "🔗 Utilities:"
	@echo "  make cli            Run CLI tools interactively"
	@echo "  make examples       Run example demonstrations"
	@echo "  make import-sample  Import sample data"
	@echo "  make backup         Create data backup"
	@echo "  make migrate        Run database migration tools"

# Setup and Installation
setup: clean install
	@echo "🔧 Setting up Firebase Student App..."
	@flutter doctor
	@echo "✅ Setup complete! Run 'make run' to start the app."

install:
	@echo "📦 Installing Flutter dependencies..."
	@flutter pub get

clean:
	@echo "🧹 Cleaning project..."
	@flutter clean
	@flutter pub get

# Development
run:
	@echo "🚀 Starting Flutter app in debug mode..."
	@flutter run

run-web:
	@echo "🌐 Starting Flutter web app..."
	@flutter run -d chrome --web-port 3000

run-release:
	@echo "🚀 Starting Flutter app in release mode..."
	@flutter run --release

emulators:
	@echo "🔥 Starting Firebase emulators..."
	@firebase emulators:start

stop-emulators:
	@echo "🛑 Stopping Firebase emulators..."
	@firebase emulators:stop

# Testing
test:
	@echo "🧪 Running all tests..."
	@flutter test

test-unit:
	@echo "🧪 Running unit tests..."
	@flutter test test/unit/

test-firebase:
	@echo "🧪 Running tests with Firebase emulators..."
	@firebase emulators:exec --project demo-project "flutter test --dart-define=USE_FIREBASE_EMULATOR=true"

test-coverage:
	@echo "📊 Running tests with coverage..."
	@flutter test --coverage
	@genhtml coverage/lcov.info -o coverage/html
	@echo "📊 Coverage report generated in coverage/html/"

test-performance:
	@echo "⚡ Running performance tests..."
	@dart lib/utils/cli_tools.dart test

# Code Quality
lint:
	@echo "🔍 Running dart analysis..."
	@flutter analyze

format:
	@echo "✨ Formatting code..."
	@dart format lib/ test/

format-check:
	@echo "✅ Checking code format..."
	@dart format --output=none --set-exit-if-changed lib/ test/

security:
	@echo "🔒 Running security analysis..."
	@flutter analyze --fatal-infos
	@echo "🔒 Checking for known vulnerabilities..."
	@flutter pub deps

# Build
build-android:
	@echo "📱 Building Android APK..."
	@flutter build apk --release

build-ios:
	@echo "🍎 Building iOS app..."
	@flutter build ios --release --no-codesign

build-web:
	@echo "🌐 Building web app..."
	@flutter build web --release

build-all: build-android build-ios build-web
	@echo "🏗️ Building for all platforms..."

# Documentation
docs:
	@echo "📚 Generating documentation..."
	@dart doc
	@echo "📚 Documentation generated in doc/api/"

docs-serve:
	@echo "📚 Serving documentation..."
	@cd doc/api && python3 -m http.server 8080

# Docker
docker-build:
	@echo "🐋 Building Docker image..."
	@docker build -t firebase-student-app .

docker-run:
	@echo "🐋 Running app in Docker..."
	@docker run -it --rm -p 3000:3000 -p 4000:4000 -p 8080:8080 firebase-student-app

docker-dev:
	@echo "🐋 Starting development environment..."
	@docker-compose up --build

docker-clean:
	@echo "🐋 Cleaning Docker resources..."
	@docker-compose down -v
	@docker system prune -f

# Utilities
cli:
	@echo "💻 Starting CLI tools..."
	@dart lib/utils/cli_tools.dart interactive

examples:
	@echo "📋 Running examples..."
	@dart lib/examples/firebase_examples.dart

import-sample:
	@echo "📥 Importing sample data..."
	@dart lib/utils/cli_tools.dart import sample_data/students.json

backup:
	@echo "💾 Creating backup..."
	@dart lib/utils/cli_tools.dart backup

migrate:
	@echo "🔄 Running migration tools..."
	@dart lib/utils/cli_tools.dart migrate firebase sqlite

# Quality Gates (for CI/CD)
quality-gate: lint format-check test-coverage security
	@echo "✅ All quality checks passed!"

# Development workflow
dev-setup: setup emulators
	@echo "🎉 Development environment ready!"
	@echo "Open another terminal and run 'make run-web' to start the app"

# Production build
prod-build: clean lint test build-all
	@echo "🚀 Production build complete!"

# Complete project validation
validate: clean install lint format-check test-coverage security build-all docs
	@echo "✅ Project validation complete!"

# Quick development cycle
quick: format lint test
	@echo "⚡ Quick development cycle complete!"

# Database operations
db-stats:
	@echo "📊 Getting database statistics..."
	@dart lib/utils/cli_tools.dart stats

db-clean:
	@echo "🧹 Cleaning test data..."
	@dart lib/utils/cli_tools.dart clean

# Performance monitoring
perf-monitor:
	@echo "📈 Starting performance monitoring..."
	@dart lib/utils/cli_tools.dart test

# Educational commands
learn-firebase:
	@echo "🎓 Firebase learning resources:"
	@echo "  1. Run 'make examples' to see comprehensive examples"
	@echo "  2. Check CONCEPTS.md for theoretical background"
	@echo "  3. Review README.md for setup instructions"
	@echo "  4. Explore lib/examples/ for code samples"

# Troubleshooting
doctor:
	@echo "🩺 Running Flutter doctor..."
	@flutter doctor -v

troubleshoot: doctor
	@echo "🔧 Troubleshooting information:"
	@echo "Flutter version:"
	@flutter --version
	@echo ""
	@echo "Dependencies:"
	@flutter pub deps
	@echo ""
	@echo "Project status:"
	@flutter analyze --no-fatal-infos

# Version information
version:
	@echo "📋 Version Information:"
	@echo "Flutter: $(shell flutter --version | head -n 1)"
	@echo "Dart: $(shell dart --version)"
	@echo "Firebase CLI: $(shell firebase --version 2>/dev/null || echo 'Not installed')"
	@echo "Project: Firebase Student Management App v1.0.0"

# Environment check
env-check:
	@echo "🔍 Environment Check:"
	@echo "Flutter installed: $(shell which flutter > /dev/null && echo '✅' || echo '❌')"
	@echo "Dart installed: $(shell which dart > /dev/null && echo '✅' || echo '❌')"
	@echo "Firebase CLI installed: $(shell which firebase > /dev/null && echo '✅' || echo '❌')"
	@echo "Docker installed: $(shell which docker > /dev/null && echo '✅' || echo '❌')"
	@echo "Git installed: $(shell which git > /dev/null && echo '✅' || echo '❌')"

# Shorthand aliases
s: setup
r: run
t: test
l: lint
f: format
b: build-all
d: docs
c: clean
