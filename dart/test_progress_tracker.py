#!/usr/bin/env python3
"""
Test Progress Tracker (Enhanced)
===============================
A simplified version of the Dart Test Analyzer that focuses on showing
students their progress as they add more test files.

ENHANCED FEATURES:
- Respects "//No test" exclusions when calculating progress
- Shows excluded functions separately  
- Provides accurate coverage percentages

This script is designed for incremental development - run it after creating
each new test file to see your coverage improve!
"""

import os
import sys
import re
from pathlib import Path
from datetime import datetime

def has_no_test_comment(content: str, lines: list, line_number: int) -> bool:
    """
    Check if a function has a "//No test" comment.
    
    Args:
        content: Full file content
        lines: File content split into lines  
        line_number: 1-based line number where function is declared
        
    Returns:
        True if "//No test" comment is found, False otherwise
    """
    # Pattern to detect "//No test" comments (case insensitive)
    no_test_pattern = re.compile(r'//\s*no\s*test\b', re.IGNORECASE)
    
    # Convert to 0-based index
    line_index = line_number - 1
    
    if line_index < 0 or line_index >= len(lines):
        return False
    
    # Check current line for //No test comment
    current_line = lines[line_index]
    if no_test_pattern.search(current_line):
        return True
    
    # Check previous line for //No test comment
    if line_index > 0:
        previous_line = lines[line_index - 1]
        if no_test_pattern.search(previous_line):
            return True
    
    return False

def count_testable_functions(file_path: Path) -> tuple:
    """
    Count functions in a Dart file, excluding those marked with //No test.
    
    Args:
        file_path: Path to the Dart source file
        
    Returns:
        Tuple of (total_functions, testable_functions, excluded_functions)
    """
    if not file_path.exists():
        return 0, 0, 0
    
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
            lines = content.split('\n')
    except Exception:
        return 0, 0, 0
    
    # Simple function pattern (similar to main analyzer)
    function_pattern = re.compile(
        r'^\s*(?:static\s+)?(?:@override\s+)?(?:Future<\w+>\s+|void\s+|\w+\s+)?'
        r'(\w+)\s*\([^)]*\)\s*(?:=>\s*[^;]+;|{)',
        re.MULTILINE
    )
    
    total_functions = 0
    excluded_functions = 0
    
    for match in function_pattern.finditer(content):
        func_name = match.group(1)
        line_num = content[:match.start()].count('\n') + 1
        
        # Skip main function and constructors (same logic as main analyzer)
        if func_name not in ['main', 'toString'] and not func_name[0].isupper():
            total_functions += 1
            
            # Check if this function should be excluded
            if has_no_test_comment(content, lines, line_num):
                excluded_functions += 1
    
    testable_functions = total_functions - excluded_functions
    return total_functions, testable_functions, excluded_functions

def count_files(directory: Path, pattern: str) -> int:
    """Count files matching a pattern in a directory."""
    if not directory.exists():
        return 0
    return len(list(directory.glob(pattern)))

def get_file_list(directory: Path, pattern: str) -> list:
    """Get list of files matching a pattern."""
    if not directory.exists():
        return []
    return [f.name for f in directory.glob(pattern)]

def calculate_coverage(source_files: list, test_files: list) -> tuple:
    """Calculate test coverage statistics."""
    if not source_files:
        return 0, 0, 0
    
    # Find which source files have corresponding test files
    covered_files = []
    missing_files = []
    
    for source_file in source_files:
        expected_test = source_file.replace('.dart', '_test.dart')
        if expected_test in test_files:
            covered_files.append(source_file)
        else:
            missing_files.append(source_file)
    
    coverage_percent = (len(covered_files) / len(source_files)) * 100
    return len(covered_files), len(missing_files), coverage_percent

def print_progress_bar(percentage: float, width: int = 40) -> str:
    """Create a visual progress bar."""
    filled = int(width * percentage / 100)
    bar = '█' * filled + '░' * (width - filled)
    return f"[{bar}] {percentage:.1f}%"

def analyze_function_coverage(lib_dir: Path, source_files: list) -> dict:
    """Analyze function-level coverage including //No test exclusions."""
    total_functions = 0
    total_testable = 0
    total_excluded = 0
    file_details = []
    
    for source_file_name in source_files:
        source_file_path = lib_dir / source_file_name
        total, testable, excluded = count_testable_functions(source_file_path)
        
        total_functions += total
        total_testable += testable
        total_excluded += excluded
        
        if total > 0:  # Only include files with functions
            file_details.append({
                'file': source_file_name,
                'total': total,
                'testable': testable,
                'excluded': excluded
            })
    
    return {
        'total_functions': total_functions,
        'total_testable': total_testable,
        'total_excluded': total_excluded,
        'file_details': file_details
    }

def main():
    """Run the enhanced progress tracker."""
    
    # Determine project directory
    if len(sys.argv) > 1:
        project_dir = Path(sys.argv[1])
    else:
        project_dir = Path("./1-Dart-for-Java-and-JavaScript")
    
    if not project_dir.exists():
        print(f"❌ Project directory '{project_dir}' not found!")
        print("Usage: python3 test_progress_tracker.py [project_directory]")
        return 1
    
    lib_dir = project_dir / 'lib'
    test_dir = project_dir / 'test'
    
    # Get file lists
    source_files = get_file_list(lib_dir, '*.dart')
    test_files = get_file_list(test_dir, '*_test.dart')
    
    # Calculate coverage
    covered, missing, coverage_percent = calculate_coverage(source_files, test_files)
    
    # Analyze function-level coverage
    function_analysis = analyze_function_coverage(lib_dir, source_files)
    
    # Print header
    print("🎯 DART TEST PROGRESS TRACKER (Enhanced)")
    print("=" * 55)
    print(f"📅 {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"📁 Project: {project_dir.name}")
    print()
    
    # Print summary
    print("📊 CURRENT STATUS")
    print("-" * 30)
    print(f"Source Files: {len(source_files)}")
    print(f"Test Files: {len(test_files)}")
    print(f"Covered Files: {covered}")
    print(f"Missing Tests: {missing}")
    print()
    
    # Print function-level analysis
    print("🔧 FUNCTION ANALYSIS")
    print("-" * 30)
    print(f"Total Functions/Methods: {function_analysis['total_functions']}")
    print(f"Testable Functions: {function_analysis['total_testable']}")
    print(f"Excluded (//No test): {function_analysis['total_excluded']}")
    if function_analysis['total_testable'] > 0:
        testable_coverage = (function_analysis['total_testable'] / 
                           (function_analysis['total_testable'] + function_analysis['total_excluded'])) * 100
        print(f"Testable Coverage: {testable_coverage:.1f}%")
    print()
    
    # Print progress bar
    print("📈 TEST COVERAGE PROGRESS")
    print("-" * 30)
    print(print_progress_bar(coverage_percent))
    print()
    
    # Show status based on coverage
    if coverage_percent == 100:
        print("🎉 CONGRATULATIONS! You have achieved 100% test file coverage!")
        print("🏆 Next steps:")
        print("   • Run the full analyzer to check function-level coverage")
        print("   • Add more comprehensive tests for each function")
        print("   • Consider adding integration tests")
    elif coverage_percent >= 80:
        print("🌟 EXCELLENT PROGRESS! You're almost there!")
        print(f"💪 Only {missing} more test files to go!")
    elif coverage_percent >= 50:
        print("👍 GOOD WORK! You're making solid progress!")
        print(f"🎯 {missing} more test files needed for full coverage")
    elif coverage_percent >= 25:
        print("🚀 GETTING STARTED! Keep adding those tests!")
        print(f"💡 {missing} more test files to create")
    else:
        print("🏁 STARTING POINT - Let's build those tests!")
        print(f"📝 Create {missing} test files to achieve full coverage")
    
    print()
    
    # Show missing files if any
    if missing > 0:
        print("📋 MISSING TEST FILES")
        print("-" * 30)
        missing_list = []
        for source_file in source_files:
            expected_test = source_file.replace('.dart', '_test.dart')
            if expected_test not in test_files:
                missing_list.append((source_file, expected_test))
        
        # Show first 5 missing files to avoid overwhelming output
        for i, (source, expected) in enumerate(missing_list[:5]):
            print(f"❌ {source} → Create: {expected}")
        
        if len(missing_list) > 5:
            print(f"... and {len(missing_list) - 5} more")
        
        print()
        
        # Suggest next steps
        print("💡 QUICK WINS")
        print("-" * 30)
        if missing_list:
            next_file = missing_list[0][1]
            print(f"• Start with: {next_file}")
            print(f"• Template: test/{next_file}")
            print("• Use 'group()' and 'test()' functions")
            print("• Test each function in the source file")
            print("• Use //No test to exclude simple functions")
    
    # Show recently created tests
    if test_files:
        print()
        print("✅ EXISTING TEST FILES")
        print("-" * 30)
        for test_file in sorted(test_files):
            print(f"✓ {test_file}")
    
    # Show files with excluded functions
    excluded_files = [f for f in function_analysis['file_details'] if f['excluded'] > 0]
    if excluded_files:
        print()
        print("ℹ️  FILES WITH EXCLUDED FUNCTIONS")
        print("-" * 30)
        for file_info in excluded_files:
            print(f"📁 {file_info['file']}: {file_info['excluded']} excluded, "
                  f"{file_info['testable']} testable")
    
    print()
    print("🔧 COMMANDS TO TRY")
    print("-" * 30)
    print("• Run all tests: dart test")
    print("• Run specific test: dart test test/YourFile_test.dart")
    print("• Full analysis: python3 dart_test_analyzer.py")
    print("• Generate templates: python3 generate_test_template.py --all")
    print("• Check progress: python3 test_progress_tracker.py")
    
    print()
    print("📖 TIP: Use //No test comments to exclude simple functions:")
    print("   void simpleUtility() { //No test")
    print("   or:")
    print("   //No test") 
    print("   void anotherFunction() {")
    
    return 0

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
