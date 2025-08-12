#!/usr/bin/env python3
"""
Dart Test Template Generator (Enhanced)
=======================================
Automatically generates test file templates for Dart source files.

ENHANCED FEATURES:
- Respects "//No test" exclusions when generating templates
- Shows excluded functions in comments for reference
- Provides better template structure for testable functions

This tool analyzes a Dart source file and creates a basic test template
with placeholder tests for each function it finds (excluding those marked with //No test).

Usage:
    python3 generate_test_template.py SourceFile.dart
    python3 generate_test_template.py --all  # Generate for all missing tests
"""

import os
import re
import sys
from pathlib import Path
from datetime import datetime

class TestTemplateGenerator:
    """Generates test templates for Dart source files."""
    
    def __init__(self):
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
        
        # Pattern to detect "//No test" comments (case insensitive)
        self.no_test_pattern = re.compile(
            r'//\s*no\s*test\b',
            re.IGNORECASE
        )

    def _has_no_test_comment(self, content: str, lines: list, line_number: int) -> bool:
        """
        Check if a function has a "//No test" comment.
        
        Args:
            content: Full file content
            lines: File content split into lines  
            line_number: 1-based line number where function is declared
            
        Returns:
            True if "//No test" comment is found, False otherwise
        """
        # Convert to 0-based index
        line_index = line_number - 1
        
        if line_index < 0 or line_index >= len(lines):
            return False
        
        # Check current line for //No test comment
        current_line = lines[line_index]
        if self.no_test_pattern.search(current_line):
            return True
        
        # Check previous line for //No test comment
        if line_index > 0:
            previous_line = lines[line_index - 1]
            if self.no_test_pattern.search(previous_line):
                return True
        
        return False

    def extract_functions(self, file_path: Path) -> dict:
        """Extract functions, classes, and methods from a Dart file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as file:
                content = file.read()
                lines = content.split('\n')
        except Exception as e:
            print(f"❌ Error reading {file_path}: {e}")
            return {}
        
        # Find classes and mixins
        classes = []
        for match in self.class_pattern.finditer(content):
            classes.append(match.group(1))
        
        for match in self.mixin_pattern.finditer(content):
            classes.append(match.group(1))
        
        # Find functions and categorize them
        testable_functions = []
        excluded_functions = []
        
        for match in self.function_pattern.finditer(content):
            func_name = match.group(1)
            line_num = content[:match.start()].count('\n') + 1
            
            # Skip constructors, toString, and main
            if func_name not in ['main', 'toString'] and not func_name[0].isupper():
                # Check if function should be excluded
                if self._has_no_test_comment(content, lines, line_num):
                    excluded_functions.append({
                        'name': func_name,
                        'line': line_num
                    })
                else:
                    testable_functions.append(func_name)
        
        return {
            'testable_functions': testable_functions,
            'excluded_functions': excluded_functions,
            'classes': classes,
            'file_content': content
        }

    def generate_template(self, source_file: Path) -> str:
        """Generate a test template for the given source file."""
        
        # Extract information from source file
        info = self.extract_functions(source_file)
        testable_functions = info['testable_functions']
        excluded_functions = info['excluded_functions']
        classes = info['classes']
        
        # Get the import path (relative to test directory)
        import_path = f"../lib/{source_file.name}"
        
        # Start building the template
        template_lines = [
            "import 'package:test/test.dart';",
            f"import '{import_path}';",
            "",
            f"// Test file for {source_file.name}",
            f"// Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        ]
        
        # Add information about excluded functions if any
        if excluded_functions:
            template_lines.extend([
                f"// NOTE: {len(excluded_functions)} functions are excluded from testing (marked with //No test):",
            ])
            for excluded in excluded_functions:
                template_lines.append(f"//   - {excluded['name']} (line {excluded['line']})")
        
        template_lines.extend([
            f"// TODO: Implement comprehensive tests for {len(testable_functions)} testable functions",
            "",
            "void main() {"
        ])
        
        # Generate test groups for classes
        if classes:
            for class_name in classes:
                template_lines.extend([
                    f"  group('{class_name} Tests', () {{",
                    f"    test('should create {class_name} instance', () {{",
                    f"      // TODO: Test {class_name} instantiation",
                    f"      // final instance = {class_name}();",
                    f"      // expect(instance, isNotNull);",
                    f"    }});",
                    "",
                    f"    // TODO: Add more tests for {class_name} methods",
                    f"    // NOTE: Methods marked with //No test are excluded from requirements",
                    f"  }});",
                    ""
                ])
        
        # Generate tests for testable functions only
        if testable_functions:
            template_lines.extend([
                "  group('Function Tests', () {"
            ])
            
            for func_name in testable_functions:
                # Create a test description based on function name
                test_desc = self._generate_test_description(func_name)
                
                template_lines.extend([
                    f"    test('{test_desc}', () {{",
                    f"      // TODO: Test {func_name} function",
                    f"      // Example: expect(() => {func_name}(), prints(contains('expected output')));",
                    f"      // Or: final result = {func_name}(); expect(result, equals(expectedValue));",
                    f"    }});",
                    ""
                ])
            
            template_lines.append("  });")
        
        # Add integration tests section
        template_lines.extend([
            "",
            "  group('Integration Tests', () {",
            "    test('all functions should work together', () {",
            "      // TODO: Add integration tests that combine multiple functions",
            "      // This helps ensure the overall functionality works correctly",
            "    });",
            "  });",
            "",
            "  group('Edge Cases', () {",
            "    test('functions should handle edge cases gracefully', () {",
            "      // TODO: Test with null values, empty strings, boundary conditions, etc.",
            "      // Examples:",
            "      // - Empty inputs",
            "      // - Null values (if applicable)",
            "      // - Very large numbers",
            "      // - Special characters",
            "    });",
            "  });"
        ])
        
        # Add information comment about excluded functions at the bottom
        if excluded_functions:
            template_lines.extend([
                "",
                "  // The following functions are excluded from testing (//No test):",
            ])
            for excluded in excluded_functions:
                template_lines.append(f"  // - {excluded['name']} (line {excluded['line']})")
            
            template_lines.extend([
                "  // If you need to test any of these, remove the //No test comment",
                "  // from the source file and regenerate this template."
            ])
        
        template_lines.append("}")
        
        return "\n".join(template_lines)

    def _generate_test_description(self, func_name: str) -> str:
        """Generate a descriptive test name based on function name."""
        # Convert camelCase to words
        words = re.sub(r'([A-Z])', r' \1', func_name).strip().lower()
        
        # Add common test prefixes
        if 'example' in words:
            return f"{func_name} should demonstrate functionality correctly"
        elif 'get' in words or 'fetch' in words:
            return f"{func_name} should return correct value"
        elif 'set' in words or 'update' in words:
            return f"{func_name} should update value correctly"
        elif 'create' in words or 'build' in words:
            return f"{func_name} should create object correctly"
        elif 'validate' in words or 'check' in words:
            return f"{func_name} should validate input correctly"
        else:
            return f"{func_name} should work correctly"

    def create_test_file(self, source_file: Path, output_dir: Path) -> bool:
        """Create a test file for the given source file."""
        
        # Generate template content
        template_content = self.generate_template(source_file)
        
        # Determine output file name
        test_file_name = source_file.stem + '_test.dart'
        output_file = output_dir / test_file_name
        
        # Check if file already exists
        if output_file.exists():
            response = input(f"Test file {test_file_name} already exists. Overwrite? (y/N): ")
            if response.lower() != 'y':
                print(f"⏭️  Skipped {test_file_name}")
                return False
        
        # Analyze what we're generating
        info = self.extract_functions(source_file)
        testable_count = len(info['testable_functions'])
        excluded_count = len(info['excluded_functions'])
        
        # Write template to file
        try:
            with open(output_file, 'w', encoding='utf-8') as file:
                file.write(template_content)
            
            print(f"✅ Created {test_file_name}")
            if excluded_count > 0:
                print(f"   📝 {testable_count} functions require tests, {excluded_count} excluded (//No test)")
            else:
                print(f"   📝 {testable_count} functions require tests")
            return True
            
        except Exception as e:
            print(f"❌ Error creating {test_file_name}: {e}")
            return False

def main():
    """Main function for the test template generator."""
    
    if len(sys.argv) < 2:
        print("Usage: python3 generate_test_template.py <SourceFile.dart>")
        print("   or: python3 generate_test_template.py --all")
        return 1
    
    # Determine project directory
    project_dir = Path("./1-Dart-for-Java-and-JavaScript")
    lib_dir = project_dir / 'lib'
    test_dir = project_dir / 'test'
    
    if not lib_dir.exists():
        print(f"❌ Source directory {lib_dir} not found!")
        return 1
    
    # Create test directory if it doesn't exist
    test_dir.mkdir(exist_ok=True)
    
    generator = TestTemplateGenerator()
    
    print("🧪 DART TEST TEMPLATE GENERATOR (Enhanced)")
    print("=" * 45)
    print("✨ Now with //No test exclusion support!")
    print()
    
    if sys.argv[1] == '--all':
        # Generate templates for all source files that don't have tests
        source_files = list(lib_dir.glob('*.dart'))
        existing_tests = {f.stem.replace('_test', '') for f in test_dir.glob('*_test.dart')}
        
        files_to_process = [f for f in source_files if f.stem not in existing_tests]
        
        if not files_to_process:
            print("✅ All source files already have corresponding test files!")
            return 0
        
        print(f"📁 Found {len(files_to_process)} source files without tests:")
        for source_file in files_to_process:
            print(f"   • {source_file.name}")
        print()
        
        created_count = 0
        total_testable = 0
        total_excluded = 0
        
        for source_file in files_to_process:
            info = generator.extract_functions(source_file)
            testable_count = len(info['testable_functions'])
            excluded_count = len(info['excluded_functions'])
            
            if generator.create_test_file(source_file, test_dir):
                created_count += 1
                total_testable += testable_count
                total_excluded += excluded_count
        
        print()
        print(f"🎉 Created {created_count} test template files!")
        print(f"📊 Summary:")
        print(f"   • {total_testable} functions require tests")
        print(f"   • {total_excluded} functions excluded (//No test)")
        
        if total_excluded > 0:
            print()
            print("💡 TIP: Functions marked with //No test are excluded from test requirements.")
            print("   Review these exclusions to ensure they're appropriate:")
            print("   • Simple utility functions")
            print("   • Trivial getters/setters")
            print("   • Functions difficult to test meaningfully")
        
    else:
        # Generate template for specific file
        source_file_name = sys.argv[1]
        source_file = lib_dir / source_file_name
        
        if not source_file.exists():
            print(f"❌ Source file {source_file} not found!")
            return 1
        
        print(f"📝 Generating test template for {source_file_name}...")
        
        # Show analysis before generating
        info = generator.extract_functions(source_file)
        testable_count = len(info['testable_functions'])
        excluded_count = len(info['excluded_functions'])
        
        print(f"🔍 Analysis: {testable_count + excluded_count} total functions found")
        if excluded_count > 0:
            print(f"   ⏭️  {excluded_count} functions excluded (//No test)")
            print(f"   ✅ {testable_count} functions will get test templates")
        else:
            print(f"   ✅ All {testable_count} functions will get test templates")
        print()
        
        if generator.create_test_file(source_file, test_dir):
            print("🎉 Test template created successfully!")
        else:
            print("❌ Failed to create test template")
            return 1
    
    print()
    print("💡 NEXT STEPS:")
    print("• Open the generated test files")
    print("• Replace TODO comments with actual test code")
    print("• Run 'dart test' to verify your tests work")
    print("• Use 'python3 test_progress_tracker.py' to monitor progress")
    print("• Add //No test comments to exclude simple functions from requirements")
    
    return 0

if __name__ == "__main__":
    exit_code = main()
    sys.exit(exit_code)
