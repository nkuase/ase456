# Dart Unit Tests for Cascade Examples

This directory contains unit tests for the Cascade.dart examples used in the ASE456 Advanced Software Engineering course.

## Project Structure

```
/test/
├── cascade_test.dart         # Unit tests for cascade operator examples
├── pubspec.yaml             # Project dependencies
├── run_tests.sh             # Shell script to run tests
└── README.md                # This file
```

## Running the Tests

### Method 1: Using the Shell Script (Recommended)

1. Make the script executable:
```bash
chmod +x run_tests.sh
```

2. Run the tests:
```bash
./run_tests.sh
```

### Method 2: Manual Commands

1. Install dependencies:
```bash
dart pub get
```

2. Run the tests:
```bash
dart test test/cascade_test.dart
```

### Method 3: Run with detailed output

```bash
dart test test/cascade_test.dart --reporter=expanded
```

## Test Coverage

The unit tests cover the following aspects of the cascade operator:

### Basic Cascade Operations
- List creation and manipulation using cascade operator
- Method chaining with various list operations
- Sorting and insertion operations

### Paint Class Tests
- Object initialization using cascade operator
- Property assignment verification
- toString() method validation
- Multiple object creation scenarios

### Integration Tests
- Verification of original example functions
- Behavior validation of cascadeExample() and constructorExample()

### Advanced Cascade Tests
- Object identity verification (cascade returns original object)
- Nested cascade operations
- Conditional cascade operations

## Expected Output

When all tests pass, you should see output similar to:
```
✅ All tests passed successfully!
```

## Educational Value

These tests demonstrate:
1. **Cascade Operator (`..`)**: How to chain multiple operations on the same object
2. **Method Chaining**: Fluent interface pattern in Dart
3. **Object Initialization**: Clean and readable object setup
4. **Unit Testing**: Best practices for testing Dart code
5. **Test Organization**: Grouping related tests for better maintainability

## Troubleshooting

If tests fail:
1. Ensure Dart SDK is properly installed
2. Check that all dependencies are installed (`dart pub get`)
3. Verify the Cascade.dart file is in the correct location
4. Review error messages for specific test failures

## Learning Objectives

Students will understand:
- How cascade operators improve code readability
- The difference between method chaining and cascade operations
- How to write comprehensive unit tests for Dart code
- Best practices for test organization and documentation
