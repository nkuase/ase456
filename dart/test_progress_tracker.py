#!/usr/bin/env python3
"""
Test Progress Tracker
====================
A simplified version of the Dart Test Analyzer that focuses on showing
students their progress as they add more test files.

This script is designed for incremental development - run it after creating
each new test file to see your coverage improve!
"""

import os
import sys
from pathlib import Path
from datetime import datetime

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

def main():
    """Run the simplified progress tracker."""
    
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
    
    # Print header
    print("🎯 DART TEST PROGRESS TRACKER")
    print("=" * 50)
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
    
    # Show recently created tests
    if test_files:
        print()
        print("✅ EXISTING TEST FILES")
        print("-" * 30)
        for test_file in sorted(test_files):
            print(f"✓ {test_file}")
    
    print()
    print("🔧 COMMANDS TO TRY")
    print("-" * 30)
    print("• Run all tests: dart test")
    print("• Run specific test: dart test test/YourFile_test.dart")
    print("• Full analysis: python3 dart_test_analyzer.py")
    print("• Check progress: python3 test_progress_tracker.py")
    
    return 0

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
