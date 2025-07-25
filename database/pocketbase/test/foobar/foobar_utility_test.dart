import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:pocketbase/pocketbase.dart';
import 'foobar_utility.dart';
import 'foobar_crud.dart';

void main() {
  group('FooBarUtility Simple Tests', () {
    late Directory tempDir;
    late FooBarUtility utility;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('test_');
      final pb = PocketBase('http://127.0.0.1:8090');
      final crudService = FooBarCrudService(pb);
      utility = FooBarUtility(crudService);
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('should create utility instance', () {
      // Arrange & Act already done in setUp
      
      // Assert
      expect(utility, isNotNull);
    });

    test('should create sample JSON file', () async {
      // Arrange
      final filePath = '${tempDir.path}/sample.json';
      
      // Act
      await utility.createSampleJsonFile(filePath);
      
      // Assert
      final file = File(filePath);
      expect(await file.exists(), isTrue);
      
      // Check file has content
      final content = await file.readAsString();
      expect(content.isNotEmpty, isTrue);
      
      // Check it's valid JSON
      final dynamic jsonData = jsonDecode(content);
      expect(jsonData, isA<List>());
    });

    test('should create sample JSON with correct data', () async {
      // Arrange
      final filePath = '${tempDir.path}/sample.json';
      
      // Act
      await utility.createSampleJsonFile(filePath);
      
      // Assert
      final content = await File(filePath).readAsString();
      final dynamic jsonData = jsonDecode(content);
      final List<dynamic> data = jsonData as List<dynamic>;
      
      expect(data.length, equals(5));
      expect(data[0]['foo'], equals('Hello World'));
      expect(data[0]['bar'], equals(42));
    });

    test('should create directories when needed', () async {
      // Arrange
      final nestedPath = '${tempDir.path}/nested/deep/sample.json';
      
      // Act
      await utility.createSampleJsonFile(nestedPath);
      
      // Assert
      expect(await File(nestedPath).exists(), isTrue);
    });
  });
}
