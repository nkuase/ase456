#!/usr/bin/env python3
"""
Dart Test Analyzer
==================
A comprehensive tool for analyzing Dart source files and their corresponding test files.

This script performs the following analysis:
1. Checks if each source file has a matching test file
2. Extracts functions/methods from source files
3. Verifies if each function has corresponding unit tests
4. Runs unit tests and reports pass/fail statistics
5. Captures and analyzes print statements in tests
6. Generates detailed reports

Author: University Teaching Assistant
Purpose: Educational tool for ASE456 course
"""

import os
import re
import subprocess
import json
from typing import Dict, List, Set, Tuple, Optional
from dataclasses import dataclass
from pathlib import Path
import sys
from datetime import datetime


@dataclass
class FunctionInfo:
    """Data class to store information about a function or method."""
    name: str
    type: str  # 'function', 'method', 'constructor', 'getter', 'setter'
    class_name: Optional[str] = None
    line_number: int = 0
    signature: str = ""


@dataclass
class TestInfo:
    """Data class to store information about a test case."""
    name: str
    description: str
    line_number: int = 0
    tested_function: Optional[str] = None


@dataclass
class TestResult:
    """Data class to store test execution results."""
    file_name: str
    total_tests: int = 0
    passed_tests: int = 0
    failed_tests: int = 0
    output: str = ""
    print_statements: List[str] = None

    def __post_init__(self):
        if self.print_statements is None:
            self.print_statements = []

    @property
    def pass_rate(self) -> float:
        """Calculate the pass rate as a percentage."""
        if self.total_tests == 0:
            return 0.0
        return (self.passed_tests / self.total_tests) * 100


class DartParser:
    """
    Parser class for extracting information from Dart source files.
    
    This class uses regular expressions to identify:
    - Functions and methods
    - Classes and mixins
    - Constructors
    - Getters and setters
    """

    def __init__(self):
        # Regular expressions for different Dart constructs
        self.function_pattern = re.compile(
            r'^\s*(?:static\s+)?(?:@override\s+)?(?:Future<\w+>\s+|void\s+|\w+\s+)?'
            r'(\w+)\s*\([^)]*\)\s*(?:=>\s*[^;]+;|{)',
            re.MULTILINE
        )
        
        self.class_pattern = re.compile(
            r'^\s*(?:abstract\s+)?class\s+(\w+)',
            re.MULTILINE
        )
        
        self.mixin_pattern = re.compile(
            r'^\s*mixin\s+(\w+)',
            re.MULTILINE
        )
        
        self.method_pattern = re.compile(
            r'^\s*(?:@override\s+)?(?:static\s+)?(?:Future<\w+>\s+|void\s+|\w+\s+)?'
            r'(\w+)\s*\([^)]*\)\s*(?:=>\s*[^;]+;|{)',
            re.MULTILINE
        )
        
        self.getter_pattern = re.compile(
            r'^\s*(?:@override\s+)?(?:\w+\s+)?get\s+(\w+)',
            re.MULTILINE
        )
        
        self.setter_pattern = re.compile(
            r'^\s*(?:@override\s+)?set\s+(\w+)',
            re.MULTILINE
        )

    def parse_source_file(self, file_path: str) -> List[FunctionInfo]:
        """
        Parse a Dart source file and extract function information.
        
        Args:
            file_path: Path to the Dart source file
            
        Returns:
            List of FunctionInfo objects containing function details
        """
        functions = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                lines = content.split('\n')
                
            # Find classes and mixins first
            classes = self._find_classes_and_mixins(content)
            
            # Find all functions
            functions.extend(self._find_functions(content, lines))
            
            # Find methods within classes
            functions.extend(self._find_methods_in_classes(content, lines, classes))
            
            # Find getters and setters
            functions.extend(self._find_getters_setters(content, lines, classes))
                
        except Exception as e:
            print(f"Error parsing {file_path}: {e}")
            
        return functions

    def _find_classes_and_mixins(self, content: str) -> Dict[str, Tuple[int, int]]:
        """Find all classes and mixins with their start and end positions."""
        classes = {}
        
        # Find classes
        for match in self.class_pattern.finditer(content):
            class_name = match.group(1)
            start_pos = match.start()
            end_pos = self._find_class_end(content, start_pos)
            classes[class_name] = (start_pos, end_pos)
            
        # Find mixins
        for match in self.mixin_pattern.finditer(content):
            mixin_name = match.group(1)
            start_pos = match.start()
            end_pos = self._find_class_end(content, start_pos)
            classes[mixin_name] = (start_pos, end_pos)
            
        return classes

    def _find_class_end(self, content: str, start_pos: int) -> int:
        """Find the end position of a class or mixin definition."""
        brace_count = 0
        in_class = False
        
        for i in range(start_pos, len(content)):
            char = content[i]
            if char == '{':
                brace_count += 1
                in_class = True
            elif char == '}':
                brace_count -= 1
                if in_class and brace_count == 0:
                    return i
                    
        return len(content)

    def _find_functions(self, content: str, lines: List[str]) -> List[FunctionInfo]:
        """Find standalone functions (not methods)."""
        functions = []
        
        for match in self.function_pattern.finditer(content):
            func_name = match.group(1)
            line_num = content[:match.start()].count('\n') + 1
            
            # Skip if it's inside a class/mixin
            if not self._is_inside_class(content, match.start()):
                # Skip main function and constructors
                if func_name not in ['main', 'toString'] and not func_name[0].isupper():
                    signature = self._extract_signature(lines, line_num - 1)
                    functions.append(FunctionInfo(
                        name=func_name,
                        type='function',
                        line_number=line_num,
                        signature=signature
                    ))
                    
        return functions

    def _find_methods_in_classes(self, content: str, lines: List[str], 
                                classes: Dict[str, Tuple[int, int]]) -> List[FunctionInfo]:
        """Find methods within classes and mixins."""
        methods = []
        
        for class_name, (start_pos, end_pos) in classes.items():
            class_content = content[start_pos:end_pos]
            
            for match in self.method_pattern.finditer(class_content):
                method_name = match.group(1)
                abs_pos = start_pos + match.start()
                line_num = content[:abs_pos].count('\n') + 1
                
                # Skip constructors and toString
                if method_name != class_name and method_name not in ['toString']:
                    signature = self._extract_signature(lines, line_num - 1)
                    methods.append(FunctionInfo(
                        name=method_name,
                        type='method',
                        class_name=class_name,
                        line_number=line_num,
                        signature=signature
                    ))
                    
        return methods

    def _find_getters_setters(self, content: str, lines: List[str], 
                             classes: Dict[str, Tuple[int, int]]) -> List[FunctionInfo]:
        """Find getters and setters."""
        getters_setters = []
        
        # Find getters
        for match in self.getter_pattern.finditer(content):
            getter_name = match.group(1)
            line_num = content[:match.start()].count('\n') + 1
            class_name = self._find_containing_class(content, match.start(), classes)
            
            signature = self._extract_signature(lines, line_num - 1)
            getters_setters.append(FunctionInfo(
                name=getter_name,
                type='getter',
                class_name=class_name,
                line_number=line_num,
                signature=signature
            ))
            
        # Find setters
        for match in self.setter_pattern.finditer(content):
            setter_name = match.group(1)
            line_num = content[:match.start()].count('\n') + 1
            class_name = self._find_containing_class(content, match.start(), classes)
            
            signature = self._extract_signature(lines, line_num - 1)
            getters_setters.append(FunctionInfo(
                name=setter_name,
                type='setter',
                class_name=class_name,
                line_number=line_num,
                signature=signature
            ))
            
        return getters_setters

    def _is_inside_class(self, content: str, position: int) -> bool:
        """Check if a position is inside a class or mixin definition."""
        # Look backwards for class/mixin keyword
        before = content[:position]
        
        # Count braces to determine if we're inside a class
        class_matches = list(self.class_pattern.finditer(before))
        mixin_matches = list(self.mixin_pattern.finditer(before))
        
        all_matches = class_matches + mixin_matches
        if not all_matches:
            return False
            
        # Check the last class/mixin before this position
        last_match = max(all_matches, key=lambda x: x.start())
        class_start = last_match.start()
        
        # Count braces from class start to current position
        brace_count = 0
        for i in range(class_start, position):
            if content[i] == '{':
                brace_count += 1
            elif content[i] == '}':
                brace_count -= 1
                if brace_count == 0:
                    return False
                    
        return brace_count > 0

    def _find_containing_class(self, content: str, position: int, 
                              classes: Dict[str, Tuple[int, int]]) -> Optional[str]:
        """Find which class contains the given position."""
        for class_name, (start_pos, end_pos) in classes.items():
            if start_pos <= position <= end_pos:
                return class_name
        return None

    def _extract_signature(self, lines: List[str], line_index: int) -> str:
        """Extract the function signature from the source lines."""
        if 0 <= line_index < len(lines):
            line = lines[line_index].strip()
            # Remove leading comments and annotations
            line = re.sub(r'^\s*//.*', '', line)
            line = re.sub(r'^\s*@\w+\s*', '', line)
            return line[:100] + ('...' if len(line) > 100 else '')
        return ""


class TestParser:
    """
    Parser class for extracting information from Dart test files.
    
    This class identifies:
    - Test cases and their descriptions
    - Functions being tested
    - Test structure and organization
    """

    def __init__(self):
        self.test_pattern = re.compile(
            r'test\s*\(\s*[\'"]([^\'\"]+)[\'\"]\s*,\s*\(\)\s*\{',
            re.MULTILINE
        )

    def parse_test_file(self, file_path: str) -> List[TestInfo]:
        """
        Parse a Dart test file and extract test information.
        
        Args:
            file_path: Path to the Dart test file
            
        Returns:
            List of TestInfo objects containing test details
        """
        tests = []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                
            for match in self.test_pattern.finditer(content):
                test_description = match.group(1)
                line_num = content[:match.start()].count('\n') + 1
                
                # Try to infer what function is being tested
                tested_function = self._infer_tested_function(test_description, content)
                
                tests.append(TestInfo(
                    name=f"test_{len(tests) + 1}",
                    description=test_description,
                    line_number=line_num,
                    tested_function=tested_function
                ))
                
        except Exception as e:
            print(f"Error parsing test file {file_path}: {e}")
            
        return tests

    def _infer_tested_function(self, description: str, content: str) -> Optional[str]:
        """Try to infer which function is being tested based on test description and content."""
        # Look for function calls in the test content
        words = description.lower().split()
        
        # Common patterns to identify tested functions
        function_indicators = ['can', 'should', 'test', 'verify', 'check']
        
        for word in words:
            if word not in function_indicators and len(word) > 2:
                # This might be a function name
                if re.search(rf'\b{re.escape(word)}\b', content, re.IGNORECASE):
                    return word
                    
        return None


class TestRunner:
    """
    Class responsible for running Dart tests and capturing results.
    
    This class:
    - Executes dart test commands
    - Parses test output
    - Captures print statements
    - Analyzes pass/fail statistics
    """

    def __init__(self, project_dir: str):
        self.project_dir = Path(project_dir)

    def run_tests(self, test_file: Optional[str] = None) -> TestResult:
        """
        Run Dart tests and return results.
        
        Args:
            test_file: Optional specific test file to run
            
        Returns:
            TestResult object with execution details
        """
        try:
            # Build the dart test command
            cmd = ['dart', 'test']
            if test_file:
                cmd.append(test_file)
                
            # Add verbose flag to capture more output
            cmd.extend(['--reporter', 'expanded'])
            
            # Run the command
            result = subprocess.run(
                cmd,
                cwd=self.project_dir,
                capture_output=True,
                text=True,
                timeout=60
            )
            
            # Parse the output
            return self._parse_test_output(
                test_file or "all_tests",
                result.stdout,
                result.stderr,
                result.returncode
            )
            
        except subprocess.TimeoutExpired:
            return TestResult(
                file_name=test_file or "all_tests",
                output="Test execution timed out"
            )
        except Exception as e:
            return TestResult(
                file_name=test_file or "all_tests",
                output=f"Error running tests: {e}"
            )

    def _parse_test_output(self, file_name: str, stdout: str, stderr: str, 
                          return_code: int) -> TestResult:
        """Parse the output from dart test command."""
        full_output = stdout + stderr
        
        # Extract test statistics
        passed = len(re.findall(r'✓', stdout))
        failed = len(re.findall(r'✗', stdout))
        total = passed + failed
        
        # If no test symbols found, try alternative patterns
        if total == 0:
            # Look for "All tests passed!" or similar messages
            if "All tests passed" in stdout or return_code == 0:
                # Try to count test() calls in output
                test_count = len(re.findall(r'test\s*\(', full_output))
                if test_count > 0:
                    passed = test_count
                    total = test_count
                else:
                    passed = 1  # Assume at least one test passed
                    total = 1
                    
        # Extract print statements
        print_statements = self._extract_print_statements(stdout)
        
        return TestResult(
            file_name=file_name,
            total_tests=total,
            passed_tests=passed,
            failed_tests=failed,
            output=full_output,
            print_statements=print_statements
        )

    def _extract_print_statements(self, output: str) -> List[str]:
        """Extract print statements from test output."""
        print_statements = []
        
        # Look for printed output patterns
        lines = output.split('\n')
        
        for line in lines:
            # Skip test framework output
            if any(indicator in line for indicator in ['✓', '✗', 'test', 'passed', 'failed']):
                continue
                
            # Capture lines that look like print output
            cleaned_line = line.strip()
            if cleaned_line and not cleaned_line.startswith('+') and not cleaned_line.startswith('Building'):
                print_statements.append(cleaned_line)
                
        return print_statements


class DartTestAnalyzer:
    """
    Main analyzer class that orchestrates the analysis process.
    
    This class coordinates:
    - File discovery and validation
    - Source code parsing
    - Test analysis
    - Report generation
    """

    def __init__(self, project_directory: str):
        """
        Initialize the analyzer with the project directory.
        
        Args:
            project_directory: Path to the directory containing lib/ and test/ folders
        """
        self.project_dir = Path(project_directory)
        self.lib_dir = self.project_dir / 'lib'
        self.test_dir = self.project_dir / 'test'
        
        # Initialize parsers and runner
        self.dart_parser = DartParser()
        self.test_parser = TestParser()
        self.test_runner = TestRunner(str(self.project_dir))
        
        # Storage for analysis results
        self.source_files: Dict[str, List[FunctionInfo]] = {}
        self.test_files: Dict[str, List[TestInfo]] = {}
        self.test_results: Dict[str, TestResult] = {}

    def analyze(self) -> Dict:
        """
        Perform complete analysis of the Dart project.
        
        Returns:
            Dictionary containing analysis results
        """
        print("🔍 Starting Dart Test Analysis...")
        print("=" * 50)
        
        # Step 1: Discover files
        print("📁 Discovering files...")
        source_files = self._discover_source_files()
        test_files = self._discover_test_files()
        
        print(f"Found {len(source_files)} source files")
        print(f"Found {len(test_files)} test files")
        
        # Step 2: Parse source files
        print("\n📝 Parsing source files...")
        for source_file in source_files:
            functions = self.dart_parser.parse_source_file(str(source_file))
            self.source_files[source_file.name] = functions
            print(f"  {source_file.name}: {len(functions)} functions/methods found")
        
        # Step 3: Parse test files
        print("\n🧪 Parsing test files...")
        for test_file in test_files:
            tests = self.test_parser.parse_test_file(str(test_file))
            self.test_files[test_file.name] = tests
            print(f"  {test_file.name}: {len(tests)} tests found")
        
        # Step 4: Run tests
        print("\n🏃 Running tests...")
        for test_file in test_files:
            result = self.test_runner.run_tests(str(test_file))
            self.test_results[test_file.name] = result
            print(f"  {test_file.name}: {result.passed_tests}/{result.total_tests} tests passed")
        
        # Step 5: Generate analysis results
        print("\n📊 Generating analysis...")
        return self._generate_analysis_results(source_files, test_files)

    def _discover_source_files(self) -> List[Path]:
        """Discover all Dart source files in the lib directory."""
        if not self.lib_dir.exists():
            print(f"Warning: lib directory not found at {self.lib_dir}")
            return []
            
        return list(self.lib_dir.glob('*.dart'))

    def _discover_test_files(self) -> List[Path]:
        """Discover all Dart test files in the test directory."""
        if not self.test_dir.exists():
            print(f"Warning: test directory not found at {self.test_dir}")
            return []
            
        return [f for f in self.test_dir.glob('*.dart') if f.name.endswith('_test.dart')]

    def _generate_analysis_results(self, source_files: List[Path], 
                                 test_files: List[Path]) -> Dict:
        """Generate comprehensive analysis results."""
        
        # Check for missing test files
        missing_test_files = []
        for source_file in source_files:
            expected_test_name = source_file.stem + '_test.dart'
            if not any(tf.name == expected_test_name for tf in test_files):
                missing_test_files.append({
                    'source_file': source_file.name,
                    'expected_test_file': expected_test_name
                })
        
        # Check for missing function tests
        missing_function_tests = []
        for source_file_name, functions in self.source_files.items():
            corresponding_test_file = source_file_name.replace('.dart', '_test.dart')
            
            if corresponding_test_file in self.test_files:
                tested_functions = set()
                for test in self.test_files[corresponding_test_file]:
                    if test.tested_function:
                        tested_functions.add(test.tested_function.lower())
                
                for func in functions:
                    if func.name.lower() not in tested_functions:
                        missing_function_tests.append({
                            'source_file': source_file_name,
                            'function': func.name,
                            'type': func.type,
                            'class_name': func.class_name,
                            'line_number': func.line_number
                        })
        
        # Calculate overall statistics
        total_functions = sum(len(functions) for functions in self.source_files.values())
        total_tests = sum(len(tests) for tests in self.test_files.values())
        total_test_runs = sum(result.total_tests for result in self.test_results.values())
        total_passed = sum(result.passed_tests for result in self.test_results.values())
        
        pass_rate = (total_passed / total_test_runs * 100) if total_test_runs > 0 else 0
        
        return {
            'summary': {
                'total_source_files': len(source_files),
                'total_test_files': len(test_files),
                'total_functions': total_functions,
                'total_tests': total_tests,
                'total_test_runs': total_test_runs,
                'total_passed': total_passed,
                'pass_rate': pass_rate,
                'analysis_date': datetime.now().isoformat()
            },
            'missing_test_files': missing_test_files,
            'missing_function_tests': missing_function_tests,
            'source_files': {name: [func.__dict__ for func in functions] 
                           for name, functions in self.source_files.items()},
            'test_files': {name: [test.__dict__ for test in tests] 
                         for name, tests in self.test_files.items()},
            'test_results': {name: result.__dict__ for name, result in self.test_results.items()}
        }

    def generate_report(self, results: Dict, output_file: Optional[str] = None) -> str:
        """
        Generate a comprehensive analysis report.
        
        Args:
            results: Analysis results dictionary
            output_file: Optional file path to save the report
            
        Returns:
            Report content as string
        """
        report_lines = []
        
        # Header
        report_lines.extend([
            "=" * 80,
            "DART TEST ANALYSIS REPORT",
            "=" * 80,
            f"Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
            f"Project Directory: {self.project_dir}",
            ""
        ])
        
        # Summary
        summary = results['summary']
        report_lines.extend([
            "📊 SUMMARY",
            "-" * 40,
            f"Source Files: {summary['total_source_files']}",
            f"Test Files: {summary['total_test_files']}",
            f"Total Functions/Methods: {summary['total_functions']}",
            f"Total Test Cases: {summary['total_tests']}",
            f"Test Execution Results: {summary['total_passed']}/{summary['total_test_runs']} passed",
            f"Overall Pass Rate: {summary['pass_rate']:.1f}%",
            ""
        ])
        
        # Missing Test Files
        missing_test_files = results['missing_test_files']
        report_lines.extend([
            "🚨 MISSING TEST FILES",
            "-" * 40
        ])
        
        if missing_test_files:
            for missing in missing_test_files:
                report_lines.append(f"❌ {missing['source_file']} → Missing: {missing['expected_test_file']}")
        else:
            report_lines.append("✅ All source files have corresponding test files")
            
        report_lines.append("")
        
        # Missing Function Tests
        missing_function_tests = results['missing_function_tests']
        report_lines.extend([
            "🔍 MISSING FUNCTION TESTS",
            "-" * 40
        ])
        
        if missing_function_tests:
            current_file = None
            for missing in missing_function_tests:
                if missing['source_file'] != current_file:
                    current_file = missing['source_file']
                    report_lines.append(f"\n📁 {current_file}:")
                
                class_info = f" (in {missing['class_name']})" if missing['class_name'] else ""
                report_lines.append(
                    f"  ❌ {missing['type']}: {missing['function']}{class_info} "
                    f"[line {missing['line_number']}]"
                )
        else:
            report_lines.append("✅ All functions have corresponding tests")
            
        report_lines.append("")
        
        # Test Results Details
        report_lines.extend([
            "🧪 TEST EXECUTION DETAILS",
            "-" * 40
        ])
        
        for test_file, result in results['test_results'].items():
            report_lines.extend([
                f"\n📋 {test_file}:",
                f"  Tests Run: {result['total_tests']}",
                f"  Passed: {result['passed_tests']}",
                f"  Failed: {result['failed_tests']}",
                f"  Pass Rate: {result['pass_rate']:.1f}%"
            ])
            
            if result['print_statements']:
                report_lines.append("  Print Output:")
                for stmt in result['print_statements']:
                    report_lines.append(f"    💬 {stmt}")
        
        # Function Inventory
        report_lines.extend([
            "",
            "📚 FUNCTION INVENTORY",
            "-" * 40
        ])
        
        for source_file, functions in results['source_files'].items():
            if functions:
                report_lines.append(f"\n📁 {source_file}:")
                for func in functions:
                    class_info = f" (in {func['class_name']})" if func['class_name'] else ""
                    report_lines.append(
                        f"  🔧 {func['type']}: {func['name']}{class_info} "
                        f"[line {func['line_number']}]"
                    )
        
        # Recommendations
        report_lines.extend([
            "",
            "💡 RECOMMENDATIONS",
            "-" * 40
        ])
        
        recommendations = []
        
        if missing_test_files:
            recommendations.append(
                f"Create {len(missing_test_files)} missing test files to achieve full coverage"
            )
            
        if missing_function_tests:
            recommendations.append(
                f"Add tests for {len(missing_function_tests)} untested functions/methods"
            )
            
        if summary['pass_rate'] < 100:
            recommendations.append(
                f"Fix failing tests to improve pass rate from {summary['pass_rate']:.1f}% to 100%"
            )
            
        if not recommendations:
            recommendations.append("🎉 Excellent! Your test coverage is complete.")
            
        for i, rec in enumerate(recommendations, 1):
            report_lines.append(f"{i}. {rec}")
        
        report_lines.extend(["", "=" * 80])
        
        # Join all lines
        report_content = "\n".join(report_lines)
        
        # Save to file if requested
        if output_file:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(report_content)
            print(f"📄 Report saved to: {output_file}")
        
        return report_content


def main():
    """
    Main function to run the Dart Test Analyzer.
    
    Usage:
        python dart_test_analyzer.py [project_directory]
    """
    
    # Get project directory from command line or use default
    if len(sys.argv) > 1:
        project_dir = sys.argv[1]
    else:
        # Default to the current directory's parent (assuming script is in dart/ directory)
        project_dir = "/Users/chos5/github/nkuase/ase456/dart/1-Dart-for-Java-and-JavaScript"
    
    # Validate directory
    if not os.path.exists(project_dir):
        print(f"❌ Error: Directory '{project_dir}' does not exist")
        print("\nUsage: python dart_test_analyzer.py [project_directory]")
        return 1
    
    # Create analyzer and run analysis
    analyzer = DartTestAnalyzer(project_dir)
    
    try:
        # Perform analysis
        results = analyzer.analyze()
        
        # Generate and display report
        print("\n" + "=" * 50)
        print("📄 GENERATING REPORT")
        print("=" * 50)
        
        report_file = os.path.join(os.path.dirname(__file__), 'dart_test_analysis_report.txt')
        report_content = analyzer.generate_report(results, report_file)
        
        # Display report summary
        print("\n📊 ANALYSIS COMPLETE!")
        print(f"📁 Source Files: {results['summary']['total_source_files']}")
        print(f"🧪 Test Files: {results['summary']['total_test_files']}")
        print(f"📈 Pass Rate: {results['summary']['pass_rate']:.1f}%")
        print(f"📄 Full report saved to: {report_file}")
        
        return 0
        
    except Exception as e:
        print(f"❌ Error during analysis: {e}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
