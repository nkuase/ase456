#!/bin/bash

# Simple build script for Student Management System
PROJECT_NAME="Student Management System"
DEFAULT_PORT=8080

# Colors (without -e flag issues)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    printf "${BLUE}🔧 $1${NC}\n"
}

print_success() {
    printf "${GREEN}✅ $1${NC}\n"
}

print_error() {
    printf "${RED}❌ $1${NC}\n"
}

print_info() {
    printf "${YELLOW}ℹ️  $1${NC}\n"
}

# Simple commands
case ${1:-dev} in
    "dev"|"")
        print_step "Starting development server..."
        dart pub get
        dart run build_runner clean 2>/dev/null || true
        print_success "Starting $PROJECT_NAME on http://localhost:$DEFAULT_PORT"
        print_info "Using modern Dart web APIs (package:web, idb_shim)"
        print_info "Press Ctrl+C to stop"
        dart run build_runner serve web:$DEFAULT_PORT
        ;;
    "build")
        print_step "Building for production..."
        dart pub get
        dart pub global activate webdev
        dart pub global run webdev build --release
        print_success "Build completed in build/ directory"
        ;;
    "clean")
        print_step "Cleaning..."
        dart run build_runner clean 2>/dev/null || true
        rm -rf build/ 2>/dev/null || true
        print_success "Clean completed"
        ;;
    "help")
        echo "Usage: ./build_and_run.sh [command]"
        echo ""
        echo "Commands:"
        echo "  dev    - Start development server (default)"
        echo "  build  - Build for production"
        echo "  clean  - Clean build artifacts"
        echo "  help   - Show this help"
        ;;
    *)
        print_error "Unknown command: $1"
        print_info "Run './build_and_run.sh help' for usage"
        ;;
esac
