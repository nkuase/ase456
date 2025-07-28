#!/bin/bash

# Firebase FooBar CRUD Operations - Educational Run Script
# Simple database programming course demonstration

echo "🎓 Firebase FooBar CRUD Demo - Educational Version"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

print_info() {
    echo -e "${CYAN}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${PURPLE}🔥 $1${NC}"
}

# Educational banner
show_banner() {
    echo ""
    echo "=============================================="
    echo "🎯 LEARNING OBJECTIVES:"
    echo "   • Understand Firebase CRUD operations"
    echo "   • Learn data modeling with Dart classes"
    echo "   • Practice error handling patterns"
    echo "   • Experience testing database applications"
    echo "   • Explore project organization"
    echo "=============================================="
    echo ""
}

# Project structure overview
show_structure() {
    print_header "Project Structure Overview"
    echo ""
    echo "📁 foobar/"
    echo "   ├── lib/"
    echo "   │   ├── models/"
    echo "   │   │   └── foobar.dart           # Simple data model (foo: String, bar: int)"
    echo "   │   ├── services/"
    echo "   │   │   └── foobar_crud_firebase.dart  # All CRUD operations"
    echo "   │   ├── main.dart                 # Demo application"
    echo "   │   └── firebase-config.json     # Firebase configuration"
    echo "   ├── test/                         # Unit tests for learning"
    echo "   ├── doc/                          # Marp presentation slides"
    echo "   └── pubspec.yaml                  # Simple dependencies"
    echo ""
    print_info "This structure keeps code organized and easy to understand!"
}

# Check if Dart is installed
check_dart() {
    print_step "Checking Dart installation..."
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed or not in PATH"
        echo ""
        echo "📥 How to install Dart:"
        echo "   Option 1: Install Dart SDK directly"
        echo "            https://dart.dev/get-dart"
        echo ""
        echo "   Option 2: Install Flutter (includes Dart)"
        echo "            https://flutter.dev/docs/get-started/install"
        echo ""
        echo "   Option 3: Using package managers:"
        echo "            brew install dart         # macOS"
        echo "            choco install dart-sdk    # Windows"
        echo "            sudo apt install dart     # Ubuntu"
        echo ""
        exit 1
    fi
    
    DART_VERSION=$(dart --version 2>&1 | head -n1)
    print_success "Dart is installed: $DART_VERSION"
}

# Install dependencies
install_dependencies() {
    print_step "Installing project dependencies..."
    echo ""
    echo "📦 Installing packages:"
    echo "   • firedart: Firebase client for Dart console applications"
    echo "   • test: Testing framework for unit tests"
    echo ""
    
    dart pub get
    if [ $? -eq 0 ]; then
        print_success "Dependencies installed successfully"
        echo ""
        echo "📋 What we installed:"
        echo "   ✓ firedart ^0.9.8 - Firebase/Firestore client"
        echo "   ✓ test ^1.21.0    - Testing framework"
    else
        print_error "Failed to install dependencies"
        echo ""
        echo "💡 Troubleshooting tips:"
        echo "   1. Check your internet connection"
        echo "   2. Verify pubspec.yaml syntax is correct"
        echo "   3. Try: dart pub cache repair"
        echo "   4. Check Dart version compatibility"
        exit 1
    fi
}

# Run comprehensive tests
run_tests() {
    print_step "Running comprehensive unit tests..."
    echo ""
    echo "🧪 Test Categories:"
    echo "   • FooBar Model Tests      - Data validation and serialization"
    echo "   • Service Structure Tests - CRUD method availability"
    echo "   • Main Application Tests  - Random data generation"
    echo ""
    
    dart test --reporter=expanded
    TEST_RESULT=$?
    
    echo ""
    if [ $TEST_RESULT -eq 0 ]; then
        print_success "All tests passed! 🎉"
        echo ""
        echo "📊 What the tests verified:"
        echo "   ✓ FooBar class creates objects correctly"
        echo "   ✓ Serialization to/from Map works properly"
        echo "   ✓ Copy and equality methods function as expected"
        echo "   ✓ Service class has all required CRUD methods"
        echo "   ✓ Random data generation produces valid data"
        echo "   ✓ Edge cases are handled appropriately"
    else
        print_warning "Some tests failed - this is normal for learning!"
        echo ""
        echo "📚 What to do when tests fail:"
        echo "   1. Read the test output carefully"
        echo "   2. Understand what the test was checking"
        echo "   3. Look at the failing code"
        echo "   4. Make corrections and run tests again"
        echo "   5. Ask questions if you're stuck!"
    fi
}

# Run main demo application
run_demo() {
    print_step "Running Firebase CRUD demonstration..."
    echo ""
    echo "🚀 What the demo will show:"
    echo "   1. Initialize Firebase connection"
    echo "   2. CREATE: Add new FooBar documents"
    echo "   3. READ: Retrieve documents (single and multiple)"
    echo "   4. QUERY: Filter documents by criteria"
    echo "   5. UPDATE: Modify existing documents"
    echo "   6. DELETE: Remove documents"
    echo "   7. Close connection properly"
    echo ""
    print_info "Note: This demo uses a test Firebase project"
    echo ""
    
    dart run lib/main.dart
    DEMO_RESULT=$?
    
    echo ""
    if [ $DEMO_RESULT -eq 0 ]; then
        print_success "Demo completed successfully!"
    else
        print_warning "Demo completed with warnings (expected without real Firebase)"
        echo ""
        echo "💡 To run with real Firebase:"
        echo "   1. Create your own Firebase project"
        echo "   2. Update firebase-config.json with your config"
        echo "   3. Set up Firestore database"
        echo "   4. Run the demo again"
    fi
}

# View documentation
view_docs() {
    print_step "Opening documentation..."
    echo ""
    
    if command -v npx &> /dev/null; then
        print_info "Converting Marp slides to HTML..."
        
        # Convert main slides
        npx @marp-team/marp-cli doc/firebase_crud_slides.md --html --output firebase_crud_slides.html
        if [ $? -eq 0 ]; then
            print_success "Main slides converted: firebase_crud_slides.html"
        fi
        
        # Convert best practices slides  
        npx @marp-team/marp-cli doc/firebase_best_practices.md --html --output firebase_best_practices.html
        if [ $? -eq 0 ]; then
            print_success "Best practices slides converted: firebase_best_practices.html"
        fi
        
        # Try to open in browser
        if command -v open &> /dev/null; then
            open firebase_crud_slides.html
        elif command -v xdg-open &> /dev/null; then
            xdg-open firebase_crud_slides.html
        else
            print_info "Open firebase_crud_slides.html in your browser"
        fi
        
    else
        print_warning "Marp not available. Showing documentation locations:"
        echo ""
        echo "📚 Available documentation:"
        echo "   • doc/firebase_crud_slides.md     - Main CRUD tutorial"
        echo "   • doc/firebase_best_practices.md  - Advanced best practices"
        echo ""
        print_info "To view as slides, install Marp: npm install -g @marp-team/marp-cli"
    fi
}

# Educational summary
show_educational_summary() {
    echo ""
    print_header "Educational Summary"
    echo ""
    echo "🎓 What we learned today:"
    echo ""
    echo "📦 Data Modeling:"
    echo "   • Simple Dart classes with required fields"
    echo "   • Serialization to/from Map for Firebase"
    echo "   • Nullable types for optional fields"
    echo ""
    echo "🔥 Firebase Operations:"
    echo "   • CREATE: Adding new documents to collections"
    echo "   • READ: Retrieving single documents and collections"  
    echo "   • QUERY: Filtering documents with where clauses"
    echo "   • UPDATE: Modifying existing documents"
    echo "   • DELETE: Removing documents from collections"
    echo ""
    echo "🛡️ Best Practices:"
    echo "   • Always handle errors with try-catch"
    echo "   • Use nullable return types for operations that can fail"
    echo "   • Close database connections when done"
    echo "   • Validate data before sending to database"
    echo ""
    echo "🧪 Testing:"
    echo "   • Unit tests for models and business logic"
    echo "   • Integration tests for database operations"
    echo "   • Edge case testing for robustness"
    echo ""
    echo "🏗️ Project Organization:"
    echo "   • Separate models from business logic"
    echo "   • Keep database operations in service classes"
    echo "   • Organize tests to match source structure"
    echo "   • Document code with clear comments"
}

# Compare with other approaches
show_comparison() {
    echo ""
    print_header "Firebase vs Other Database Approaches"
    echo ""
    echo "🔄 Firebase vs SQL Database:"
    echo ""
    echo "📊 Data Structure:"
    echo "   Firebase: Document-based (JSON-like)"
    echo "   SQL:      Table-based with relationships"
    echo ""
    echo "🔍 Queries:"
    echo "   Firebase: Limited queries, real-time subscriptions"
    echo "   SQL:      Full SQL with JOINs, complex conditions"
    echo ""
    echo "🌐 Deployment:"
    echo "   Firebase: Cloud-hosted, managed service"
    echo "   SQL:      Self-hosted or cloud-managed"
    echo ""
    echo "⚡ Real-time Features:"
    echo "   Firebase: Built-in real-time listeners"
    echo "   SQL:      Requires additional implementation"
    echo ""
    echo "💰 Cost Model:"
    echo "   Firebase: Pay per read/write/storage"
    echo "   SQL:      Pay for server/instance time"
    echo ""
    print_success "Both have their place depending on requirements!"
}

# Next steps for students
show_next_steps() {
    echo ""
    print_header "Next Steps for Students"
    echo ""
    echo "🚀 Immediate Practice:"
    echo "   1. Modify the FooBar model - add more fields"
    echo "   2. Create additional query methods in the service"
    echo "   3. Write more comprehensive tests"
    echo "   4. Experiment with different data types"
    echo ""
    echo "🔧 Technical Improvements:"
    echo "   5. Add input validation to the model"
    echo "   6. Implement batch operations for multiple documents"
    echo "   7. Add error recovery and retry logic"
    echo "   8. Create a configuration system for different environments"
    echo ""
    echo "🌟 Advanced Projects:"
    echo "   9. Build a Flutter mobile app using this backend"
    echo "   10. Add user authentication and security rules"
    echo "   11. Implement real-time data synchronization"
    echo "   12. Create a web admin interface"
    echo ""
    echo "📚 Learning Resources:"
    echo "   • Firebase Documentation: https://firebase.google.com/docs"
    echo "   • Dart Language Tour: https://dart.dev/guides/language/language-tour"
    echo "   • Flutter Development: https://flutter.dev/docs"
    echo "   • Database Design Principles: Study SQL and NoSQL patterns"
}

# Show help
show_help() {
    echo ""
    echo "🆘 Usage: ./run.sh [option]"
    echo ""
    echo "Available options:"
    echo "  structure  - Show project structure overview"
    echo "  test       - Run unit tests only"
    echo "  demo       - Run Firebase CRUD demo only"
    echo "  check      - Check Dart installation only"
    echo "  deps       - Install dependencies only"
    echo "  docs       - View Marp documentation slides"
    echo "  compare    - Compare Firebase vs other databases"
    echo "  next       - Show next steps for students"
    echo "  help       - Show this help message"
    echo ""
    echo "Default (no option): Run complete educational workflow"
    echo ""
    echo "📝 Examples:"
    echo "  ./run.sh           # Run everything (recommended for first time)"
    echo "  ./run.sh test      # Just run the tests"
    echo "  ./run.sh demo      # Just run the demo"
    echo "  ./run.sh docs      # View the presentation slides"
    echo "  ./run.sh structure # See how the project is organized"
}

# Main execution logic
main() {
    case ${1:-"all"} in
        "structure")
            show_banner
            show_structure
            ;;
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
        "docs")
            view_docs
            ;;
        "compare")
            show_comparison
            ;;
        "next")
            show_next_steps
            ;;
        "help")
            show_help
            ;;
        "all"|*)
            show_banner
            check_dart
            echo ""
            install_dependencies
            echo ""
            run_tests
            echo ""
            run_demo
            show_educational_summary
            show_comparison
            show_next_steps
            ;;
    esac
}

# Make sure we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "This script must be run from the foobar project root directory"
    print_error "Expected to find pubspec.yaml in current directory"
    echo ""
    echo "💡 Make sure you're in the right directory:"
    echo "   cd /path/to/foobar"
    echo "   ./run.sh"
    exit 1
fi

# Run main function with all arguments
main "$@"

echo ""
print_success "🎉 Firebase FooBar Educational Demo Complete!"
echo ""
echo "📖 Key Takeaways:"
echo "   • Firebase provides simple CRUD operations for NoSQL data"
echo "   • Proper error handling is essential for robust applications"
echo "   • Testing helps ensure code quality and catches regressions"
echo "   • Good project structure makes code maintainable"
echo "   • Documentation helps others (and future you) understand the code"
echo ""
echo "💬 Questions? Review the slides or ask during class!"
