#!/bin/bash

# Firebase CRUD Operations - Run Script
# Educational project for database programming course

echo "🎓 Firebase CRUD Operations - Educational Demo"
echo "=" 50

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if Dart is installed
check_dart() {
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed or not in PATH"
        echo "Please install Dart: https://dart.dev/get-dart"
        exit 1
    fi
    print_success "Dart is installed"
}

# Install dependencies
install_dependencies() {
    print_step "Installing dependencies..."
    dart pub get
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
        exit 1
    fi
}

# Run tests
run_tests() {
    print_step "Running comprehensive tests..."
    echo ""
    dart test --reporter=expanded
    if [ $? -eq 0 ]; then
        print_success "All tests passed!"
    else
        print_error "Some tests failed"
        exit 1
    fi
}

# Run main demo
run_demo() {
    print_step "Running Firebase CRUD demo..."
    echo ""
    dart run lib/main.dart
    if [ $? -eq 0 ]; then
        print_success "Demo completed"
    else
        print_warning "Demo completed with warnings (expected without real Firebase setup)"
    fi
}

# Show help
show_help() {
    echo ""
    echo "Usage: ./run.sh [option]"
    echo ""
    echo "Options:"
    echo "  test     - Run tests only"
    echo "  demo     - Run demo only"
    echo "  check    - Check Dart installation only"
    echo "  deps     - Install dependencies only"
    echo "  cli      - Run Firebase CLI tutorial and demo"
    echo "  tutorial - View Firebase CLI tutorial (requires Marp)"
    echo "  help     - Show this help message"
    echo ""
    echo "Default (no option): Run full workflow (check, deps, test, demo)"
    echo ""
    echo "Examples:"
    echo "  ./run.sh          # Run everything"
    echo "  ./run.sh test     # Run tests only"
    echo "  ./run.sh demo     # Run demo only"
    echo "  ./run.sh cli      # Firebase CLI tutorial"
    echo "  ./run.sh tutorial # View CLI tutorial in browser"
}

# Compare with SQLite version
show_comparison() {
    echo ""
    print_step "🔄 Comparing Firebase vs SQLite versions:"
    echo ""
    echo "📁 Project Structure Comparison:"
    echo "   SQLite:   data/foobar.db (local file)"
    echo "   Firebase: Cloud Firestore (cloud database)"
    echo ""
    echo "🔍 Query Capabilities:"
    echo "   SQLite:   Full SQL with JOINs, complex conditions"
    echo "   Firebase: Limited queries, real-time subscriptions"
    echo ""
    echo "🌐 Connectivity:"
    echo "   SQLite:   Local only, no network required"
    echo "   Firebase: Cloud-based, real-time sync, offline support"
    echo ""
    echo "📝 Data Model:"
    echo "   SQLite:   Relational tables with typed columns"
    echo "   Firebase: Document-based with flexible JSON structure"
    echo ""
    echo "⚡ Real-time Features:"
    echo "   SQLite:   Manual refresh required"
    echo "   Firebase: Automatic real-time updates via streams"
    echo ""
    echo "🔒 Security:"
    echo "   SQLite:   File system security"
    echo "   Firebase: Cloud security rules + authentication"
    echo ""
    print_success "Both approaches have their strengths for different use cases!"
}

# Educational notes
show_educational_notes() {
    echo ""
    print_step "📚 Educational Notes:"
    echo ""
    echo "🎯 Learning Objectives Covered:"
    echo "   ✓ Firebase/Firestore CRUD operations"
    echo "   ✓ NoSQL document database concepts"
    echo "   ✓ Real-time data synchronization"
    echo "   ✓ Cloud vs local database trade-offs"
    echo "   ✓ Testing with mock services (fake_cloud_firestore)"
    echo ""
    echo "🔧 Key Firebase Concepts Demonstrated:"
    echo "   • Documents and Collections"
    echo "   • Real-time listeners (Streams)"
    echo "   • Batch operations"
    echo "   • Query limitations and workarounds"
    echo "   • Server timestamps"
    echo "   • Pagination"
    echo ""
    echo "💡 Next Steps for Students:"
    echo "   1. Compare this with the SQLite version"
    echo "   2. Set up real Firebase project"
    echo "   3. Explore Firebase Security Rules"
    echo "   4. Try building a Flutter app with this backend"
    echo "   5. Experiment with real-time features"
}

# Run Firebase CLI demo
run_cli_demo() {
    print_step "Running Firebase CLI collection creation demo..."
    echo ""
    
    # Make CLI demo script executable
    chmod +x firebase-cli-demo.sh
    
    # Run the CLI demo
    ./firebase-cli-demo.sh
    
    if [ $? -eq 0 ]; then
        print_success "Firebase CLI demo completed"
        echo ""
        print_step "📚 Next: View the complete CLI tutorial"
        echo "   cat doc/firebase_cli_tutorial.md"
        echo "   OR"
        echo "   ./run.sh tutorial"
    else
        print_warning "CLI demo completed with notes"
    fi
}

# View Firebase CLI tutorial
view_cli_tutorial() {
    print_step "Opening Firebase CLI tutorial..."
    
    if command -v npx &> /dev/null; then
        print_step "Converting tutorial to HTML..."
        npx @marp-team/marp-cli doc/firebase_cli_tutorial.md --html --output firebase-cli-tutorial.html
        
        if [ $? -eq 0 ]; then
            print_success "Tutorial converted to HTML"
            
            # Try to open in browser
            if command -v open &> /dev/null; then
                open firebase-cli-tutorial.html
            elif command -v xdg-open &> /dev/null; then
                xdg-open firebase-cli-tutorial.html
            else
                print_info "Open firebase-cli-tutorial.html in your browser"
            fi
        else
            print_warning "Failed to convert tutorial. Installing Marp..."
            npm install -g @marp-team/marp-cli
            npx @marp-team/marp-cli doc/firebase_cli_tutorial.md --html --output firebase-cli-tutorial.html
        fi
    else
        print_warning "npx not found. Showing tutorial in terminal..."
        echo ""
        cat doc/firebase_cli_tutorial.md | head -50
        echo ""
        print_info "Full tutorial available at: doc/firebase_cli_tutorial.md"
    fi
}

# Main execution logic
main() {
    case ${1:-"all"} in
        "test")
            check_dart
            install_dependencies
            run_tests
            ;;
        "demo")
            check_dart
            install_dependencies
            run_demo
            ;;
        "check")
            check_dart
            ;;
        "deps")
            check_dart
            install_dependencies
            ;;
        "cli")
            run_cli_demo
            ;;
        "tutorial")
            view_cli_tutorial
            ;;
        "help")
            show_help
            ;;
        "compare")
            show_comparison
            ;;
        "notes")
            show_educational_notes
            ;;
        "all"|*)
            check_dart
            install_dependencies
            run_tests
            echo ""
            run_demo
            show_comparison
            show_educational_notes
            ;;
    esac
}

# Make sure we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "This script must be run from the Firebase project root directory"
    print_error "Expected to find pubspec.yaml in current directory"
    exit 1
fi

# Run main function with all arguments
main "$@"

echo ""
print_success "🎉 Firebase CRUD Educational Demo Complete!"
echo ""
echo "📖 Additional Resources:"
echo "   • Firebase Documentation: https://firebase.google.com/docs"
echo "   • Dart/Flutter Firebase: https://firebase.flutter.dev/"
echo "   • Firestore Documentation: https://firebase.google.com/docs/firestore"
echo ""
echo "🔄 To compare with SQLite version:"
echo "   cd ../sqlite && ./run.sh"
