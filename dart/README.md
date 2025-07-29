# Dart Test Analyzer

A comprehensive Python tool for analyzing Dart source files and their corresponding test files, designed for educational purposes in ASE456 course.

## 🎯 Purpose

This tool helps instructors and students analyze the test coverage and quality of Dart projects by:

1. **File Coverage Analysis**: Checks if each source file has a matching test file
2. **Function Coverage Analysis**: Identifies which functions/methods lack corresponding unit tests
3. **Test Execution**: Runs all tests and provides pass/fail statistics
4. **Print Statement Analysis**: Captures and reports any print statements used in tests
5. **Comprehensive Reporting**: Generates detailed reports with actionable recommendations

## 📁 Project Structure Expected

```
your-dart-project/
├── lib/                    # Source files directory
│   ├── File1.dart
│   ├── File2.dart
│   └── ...
├── test/                   # Test files directory
│   ├── File1_test.dart
│   ├── File2_test.dart
│   └── ...
├── pubspec.yaml
└── pubspec.lock
```

## 🚀 Usage

### Basic Usage

```bash
# Run from the dart directory
python3 dart_test_analyzer.py

# Or specify a custom project directory
python3 dart_test_analyzer.py /path/to/your/dart/project
```

### Prerequisites

1. **Python 3.7+** installed
2. **Dart SDK** installed and available in PATH
3. **Project structure** with lib/ and test/ directories

## 📊 What the Tool Analyzes

### 1. Source Files Analysis
- Extracts **functions**, **methods**, **getters**, and **setters**
- Identifies **classes** and **mixins**
- Tracks line numbers and signatures
- Categorizes by type (standalone function vs. class method)

### 2. Test Files Analysis
- Finds all test cases using `test()` function
- Attempts to match tests with corresponding functions
- Extracts test descriptions and metadata

### 3. Test Execution
- Runs `dart test` command for each test file
- Captures pass/fail statistics
- Records execution output and print statements
- Calculates pass rates

### 4. Coverage Analysis
- Identifies **missing test files**
- Lists **untested functions/methods**
- Provides coverage statistics

## 📋 Report Contents

The generated report includes:

### Summary Section
- Total source files and test files count
- Function/method inventory
- Overall test pass rate
- Execution timestamp

### Missing Test Files
```
🚨 MISSING TEST FILES
❌ NullSafety.dart → Missing: NullSafety_test.dart
❌ Cascade.dart → Missing: Cascade_test.dart
```

### Missing Function Tests
```
🔍 MISSING FUNCTION TESTS
📁 NullSafety.dart:
  ❌ function: nullSafetyExample [line 7]
```

### Test Execution Results
```
🧪 TEST EXECUTION DETAILS
📋 Mixins_test.dart:
  Tests Run: 1
  Passed: 1
  Failed: 0
  Pass Rate: 100.0%
  Print Output:
    💬 Breathing through gills!
```

### Function Inventory
Complete list of all discovered functions and methods with their locations.

### Recommendations
Actionable suggestions for improving test coverage.

## 🏗️ Architecture (Educational)

The tool is designed using Object-Oriented Programming principles:

### Core Classes

#### `DartParser`
- **Purpose**: Parses Dart source files to extract functions and methods
- **Key Methods**: 
  - `parse_source_file()`: Main parsing entry point
  - `_find_functions()`: Extracts standalone functions
  - `_find_methods_in_classes()`: Extracts class methods
- **Educational Value**: Demonstrates regex parsing and AST-like analysis

#### `TestParser`
- **Purpose**: Analyzes Dart test files to identify test cases
- **Key Methods**:
  - `parse_test_file()`: Extracts test information
  - `_infer_tested_function()`: Attempts to match tests with functions
- **Educational Value**: Shows pattern matching in test code

#### `TestRunner`
- **Purpose**: Executes tests and captures results
- **Key Methods**:
  - `run_tests()`: Executes dart test command
  - `_parse_test_output()`: Analyzes test execution output
- **Educational Value**: Demonstrates subprocess management and output parsing

#### `DartTestAnalyzer`
- **Purpose**: Orchestrates the entire analysis process
- **Key Methods**:
  - `analyze()`: Main analysis workflow
  - `generate_report()`: Creates comprehensive reports
- **Educational Value**: Shows how to coordinate multiple analysis components

### Design Patterns Used

1. **Data Classes**: `FunctionInfo`, `TestInfo`, `TestResult` for structured data
2. **Strategy Pattern**: Different parsing strategies for various Dart constructs
3. **Template Method**: Consistent analysis workflow across different file types
4. **Factory Pattern**: Creating appropriate parser instances

## 🔧 Extending the Tool

Students can enhance the tool by:

1. **Adding New Parsers**: Support for other languages or test frameworks
2. **Improving Pattern Recognition**: Better function-to-test matching algorithms
3. **Enhanced Reporting**: Additional output formats (JSON, HTML, CSV)
4. **Integration**: Connect with CI/CD pipelines or IDEs

## 🐛 Common Issues and Solutions

### "dart command not found"
```bash
# Install Dart SDK
# macOS: brew install dart
# Ubuntu: sudo apt-get install dart
# Windows: choco install dart-sdk
```

### "No tests found"
- Ensure test files end with `_test.dart`
- Verify test files are in the `test/` directory
- Check that tests use proper `test()` function syntax

### "Permission denied"
```bash
chmod +x dart_test_analyzer.py
```

## 📚 Educational Objectives

This tool teaches students:

1. **File System Operations**: Directory traversal and file I/O
2. **Regular Expressions**: Pattern matching in source code
3. **Process Management**: Running external commands and capturing output
4. **Data Structures**: Organizing complex analysis results
5. **Report Generation**: Creating human-readable analysis summaries
6. **Error Handling**: Robust error management in file processing
7. **Object-Oriented Design**: Clean, maintainable code architecture

## 🤝 Contributing

Students can contribute by:
- Adding support for more Dart language features
- Improving test detection accuracy
- Creating additional report formats
- Adding performance optimizations

## 📞 Support

For issues related to the tool, please check:
1. Dart SDK installation
2. Project directory structure
3. File permissions
4. Python version compatibility

---
*Created for ASE456 - Advanced Software Engineering Course*
