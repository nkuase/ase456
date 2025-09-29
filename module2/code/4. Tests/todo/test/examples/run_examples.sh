#!/bin/bash

# =============================================================================
# 🎓 Test Examples Runner Script
# =============================================================================
# 
# This script makes it easy to run and compare the test examples
# showing the benefits of using test helpers.
#
# Usage:
#   chmod +x test/examples/run_examples.sh
#   test/examples/run_examples.sh
#
# =============================================================================

set -e  # Exit on any error

echo "=================================================================================="
echo "🎓 Flutter Test Helper Examples"
echo "=================================================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}🔷 $1${NC}"
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

# Check if we're in the right directory
if [ ! -d "test/examples" ]; then
    print_error "Please run this script from the project root directory!"
    exit 1
fi

print_step "Running Helper Usage Examples..."
echo ""

# Run the helper usage examples
if flutter test test/examples/helper_usage_example.dart; then
    print_success "Helper usage examples completed successfully!"
else
    print_error "Helper usage examples failed!"
    exit 1
fi

echo ""
echo "=================================================================================="
print_step "Example Output Analysis"
echo "=================================================================================="
echo ""

echo "📊 What you just saw:"
echo ""
echo "1. 🆚 COMPARISON TESTS:"
echo "   • Side-by-side examples showing verbose vs clean approaches"
echo "   • Same functionality, different implementation styles"
echo ""
echo "2. 📈 BENEFITS DEMONSTRATED:"
echo "   • ✅ Reduced boilerplate code"
echo "   • ✅ Improved readability"
echo "   • ✅ Better maintainability"
echo "   • ✅ Consistent patterns"
echo ""
echo "3. 🎓 EDUCATIONAL VALUE:"
echo "   • Shows progression from basic to professional testing"
echo "   • Demonstrates real-world testing patterns"
echo "   • Provides reusable code examples"
echo ""

print_step "Next Steps for Students:"
echo ""
echo "1. 📖 STUDY THE CODE:"
echo "   • Open test/examples/helper_usage_example.dart"
echo "   • Compare the 'WITHOUT' vs 'WITH' helper approaches"
echo "   • Notice the difference in code clarity"
echo ""
echo "2. 🔬 EXPERIMENT:"
echo "   • Copy helper methods to your own tests"
echo "   • Try refactoring existing tests to use helpers"
echo "   • Create your own helper methods"
echo ""
echo "3. 📚 LEARN MORE:"
echo "   • Read test/examples/README.md for detailed guidance"
echo "   • Study test/examples/widget_test_helpers_example.dart"
echo "   • Practice applying these patterns"
echo ""

print_step "For Instructors:"
echo ""
echo "📋 USE THESE EXAMPLES TO:"
echo "   • Demonstrate testing evolution and best practices"
echo "   • Show students what professional test code looks like"
echo "   • Provide reference material for assignments"
echo "   • Illustrate the DRY principle in testing"
echo ""

echo "=================================================================================="
print_success "Examples demonstration completed!"
echo "=================================================================================="
echo ""

print_warning "Remember: These are EXAMPLES showing advanced patterns."
print_warning "Your current tests work fine! Use helpers when they add real value."
echo ""
