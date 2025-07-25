# FooBar Unit Tests - Simple Educational Guide

This directory contains comprehensive yet simple unit tests for the FooBar CRUD and Utility classes, designed to teach students testing fundamentals without complex setup.

## 📁 Files Overview

- **`foobar_test.dart`** - Main test file with all unit tests (no external dependencies!)
- **`run_tests.sh`** - Simple script to run tests (make executable with `chmod +x run_tests.sh`)
- **`pubspec_test_dependencies.yaml`** - Only requires basic `test` package

## 🎯 Why This Simple Approach?

- **No mock generation** - tests run immediately without build steps
- **No external dependencies** - focuses on testing logic, not framework complexity
- **Clear examples** - students can understand every line of code
- **Immediate feedback** - run tests with just `dart test`

## 🧪 Test Categories (55+ Test Cases)

### 1. **FooBar Model Tests** 
```dart
test('should create FooBar from JSON correctly', () {
  final json = {'foo': 'test_value', 'bar': 42};
  final foobar = FooBar.fromJson(json);
  expect(foobar.foo, equals('test_value'));
});
```
**What Students Learn**: Object creation, JSON handling, basic assertions

### 2. **JSON Serialization Tests**
```dart
test('should handle JSON roundtrip correctly', () {
  final original = FooBar(foo: 'test', bar: 123);
  final json = original.toJson();
  final recreated = FooBar.fromJson(json);
  expect(recreated, equals(original));
});
```
**What Students Learn**: Data persistence, serialization patterns, data integrity

### 3. **File Operations Tests**
```dart
test('should create sample JSON file successfully', () async {
  final sampleFile = File('${tempDir.path}/sample.json');
  await utility.createSampleJsonFile(sampleFile.path);
  expect(await sampleFile.exists(), isTrue);
});
```
**What Students Learn**: File I/O, async operations, temporary file management

### 4. **Edge Cases & Error Handling**
```dart
test('should handle Unicode characters in foo field', () {
  final unicode = FooBar(foo: '测试🧪🎯📱', bar: 42);
  final recreated = FooBar.fromJson(unicode.toJson());
  expect(recreated.foo, equals('测试🧪🎯📱'));
});
```
**What Students Learn**: Real-world data challenges, internationalization, robustness

### 5. **Integration Tests**
```dart
test('should handle complete JSON workflow', () async {
  // Complete data export -> import cycle testing
});
```
**What Students Learn**: End-to-end workflows, data integrity validation

## 🚀 How to Run Tests

### Quick Start (Easiest)
```bash
# Make script executable and run
chmod +x run_tests.sh
./run_tests.sh
```

### Manual Commands
```bash
# Simple one-liner
dart test foobar_test.dart

# With detailed output
dart test foobar_test.dart --reporter=expanded

# Run specific test group
dart test foobar_test.dart --name "Model Tests"

# Run specific test
dart test foobar_test.dart --name "should create FooBar from JSON"
```

### With Dependencies (Optional)
```bash
# If you have a pubspec.yaml with test dependency
dart pub get
dart test
```

## 📋 Required Dependencies

**Minimal Setup** - Add to your `pubspec.yaml`:
```yaml
dev_dependencies:
  test: ^1.24.0  # That's it!
```

## 🔧 Key Testing Concepts Demonstrated

### **1. Arrange-Act-Assert Pattern**
```dart
test('example test', () {
  // Arrange: Setup test data
  final input = FooBar(foo: 'test', bar: 123);
  
  // Act: Execute the code under test
  final result = input.toJson();
  
  // Assert: Verify the outcome
  expect(result['foo'], equals('test'));
});
```

### **2. Testing Async Operations**
```dart
test('file operation test', () async {
  // Use async/await for file operations
  final file = File('test.json');
  await utility.createSampleJsonFile(file.path);
  expect(await file.exists(), isTrue);
});
```

### **3. Testing Error Conditions**
```dart
test('should handle invalid JSON format', () {
  expect(() {
    jsonDecode('invalid json');
  }, throwsA(isA<FormatException>()));
});
```

### **4. Safe File Testing with Cleanup**
```dart
setUp(() async {
  tempDir = await Directory.systemTemp.createTemp('test_');
});

tearDown(() async {
  await tempDir.delete(recursive: true);
});
```

### **5. Simple Mocking (No External Tools)**
```dart
class MockFooBarCrudService {
  List<FooBar> _mockData = [];
  
  Future<List<FooBar>> getAll() async => List.from(_mockData);
}
```

## 📊 Complete Test Coverage

| Test Category | Tests | What's Covered |
|---------------|--------|----------------|
| **Model Basics** | 5 tests | Creation, JSON, equality, hashCode |
| **JSON Serialization** | 6 tests | Roundtrip, special chars, edge cases |
| **File Operations** | 8 tests | Create, read, write, directories |
| **Error Handling** | 4 tests | Invalid JSON, missing files, malformed data |
| **Edge Cases** | 3 tests | Large values, Unicode, long strings |
| **Integration** | 1 test | Complete workflow validation |
| **Total** | **27 tests** | Full functionality coverage |

## 🎓 Educational Benefits

### **Students Learn:**
1. **Testing Fundamentals** - How to write effective unit tests
2. **Async Patterns** - Handling futures and file I/O
3. **Error Handling** - Testing both success and failure scenarios
4. **Data Integrity** - Ensuring data survives serialization cycles
5. **Real-World Scenarios** - Unicode, edge cases, file operations

### **No Complex Setup Required:**
- ✅ No mock generation
- ✅ No build runners
- ✅ No complex dependencies
- ✅ Works with basic Dart installation
- ✅ Immediate feedback

## 🚨 Common Student Mistakes Avoided

1. **❌ Over-complicating tests** → ✅ Simple, focused test cases
2. **❌ Not testing edge cases** → ✅ Unicode, large values, empty strings
3. **❌ Ignoring async/await** → ✅ Proper async testing patterns
4. **❌ No cleanup** → ✅ Proper setUp/tearDown for files
5. **❌ Testing implementation** → ✅ Testing behavior and outcomes

## 💡 Teaching Progression

### **Beginner Level:**
1. Run existing tests and see them pass
2. Modify test data and see how tests respond
3. Break the FooBar class and watch tests fail

### **Intermediate Level:**
1. Add new test cases for missing scenarios
2. Modify existing tests to be more comprehensive
3. Create tests for new FooBar features

### **Advanced Level:**
1. Understand the file testing patterns
2. Add integration tests for more complex workflows
3. Create tests for performance and edge cases

## 🔄 Next Steps for Students

1. **Run the tests** - Start with `./run_tests.sh`
2. **Read the output** - Understand what each test validates
3. **Modify tests** - Change expected values and see failures
4. **Add new tests** - Practice writing your own test cases
5. **Break things** - Modify FooBar class and fix the tests

This approach teaches professional testing practices while keeping the complexity manageable for students learning Dart and mobile development!

## 🏆 Why This Approach Works for Education

- **Immediate Success** - Students can run tests without setup frustration
- **Clear Examples** - Every pattern is demonstrated with simple code
- **Progressive Learning** - Start simple, add complexity gradually
- **Real-World Relevant** - Patterns used in actual mobile development
- **Zero Dependencies** - Works in any Dart environment

Perfect for classroom use and self-directed learning! 🎯
