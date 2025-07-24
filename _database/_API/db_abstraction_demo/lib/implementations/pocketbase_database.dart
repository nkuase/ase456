import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:db_abstraction_demo/interfaces/database_interface.dart';
import 'package:db_abstraction_demo/models/student.dart';

/// PocketBase implementation of the database interface
/// 
/// PocketBase is a backend-as-a-service that provides REST APIs
/// Key learning points for students:
/// 1. REST API interactions (GET, POST, PUT, DELETE)
/// 2. HTTP client usage and error handling
/// 3. JSON serialization/deserialization
/// 4. Remote database vs local database
/// 5. Network error handling and timeouts
class PocketBaseDatabase implements DatabaseInterface {
  final String baseUrl;
  final String collectionName;
  late http.Client _httpClient;
  bool _isInitialized = false;
  
  // In a real app, you'd handle authentication tokens here
  String? _authToken;

  PocketBaseDatabase({
    this.baseUrl = 'http://localhost:8090', // Default PocketBase URL
    this.collectionName = 'students',
  }) {
    _httpClient = http.Client();
  }

  @override
  String get databaseName => 'PocketBase';

  @override
  bool get isConnected => _isInitialized;

  /// Get headers for HTTP requests
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    // Add authentication token if available
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    return headers;
  }

  /// Get the full URL for API endpoints
  String _getApiUrl([String? endpoint]) {
    final base = '$baseUrl/api/collections/$collectionName/records';
    return endpoint != null ? '$base/$endpoint' : base;
  }

  @override
  Future<bool> initialize() async {
    try {
      // Test connection by making a simple request
      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl/api/health'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        _isInitialized = true;
        print('PocketBase connection established: $baseUrl');
        return true;
      } else {
        print('PocketBase health check failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Failed to connect to PocketBase: $e');
      print('Make sure PocketBase is running at: $baseUrl');
      return false;
    }
  }

  /// Ensure database is initialized before operations
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw DBAbstractionException(
        'Database not initialized. Call initialize() first.',
        operation: 'validation',
      );
    }
  }

  /// Parse PocketBase response to Student object
  Student _parseStudentFromResponse(Map<String, dynamic> data) {
    return Student(
      id: data['id'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      age: data['age'] as int,
      major: data['major'] as String,
      createdAt: DateTime.parse(data['created'] as String),
    );
  }

  @override
  Future<Student> create(Student student) async {
    _ensureInitialized();
    
    try {
      // Prepare data for PocketBase (exclude id, it will be generated)
      final data = {
        'name': student.name,
        'email': student.email,
        'age': student.age,
        'major': student.major,
      };

      final response = await _httpClient
          .post(
            Uri.parse(_getApiUrl()),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final createdStudent = _parseStudentFromResponse(responseData);
        
        print('Student created: ${createdStudent.name} (${createdStudent.id})');
        return createdStudent;
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'create',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to create student: ${student.name}',
        operation: 'create',
        originalError: e,
      );
    }
  }

  @override
  Future<Student?> read(String id) async {
    _ensureInitialized();
    
    try {
      final response = await _httpClient
          .get(
            Uri.parse(_getApiUrl(id)),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return _parseStudentFromResponse(data);
      } else if (response.statusCode == 404) {
        return null; // Student not found
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'read',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to read student with ID: $id',
        operation: 'read',
        originalError: e,
      );
    }
  }

  @override
  Future<Student> update(Student student) async {
    _ensureInitialized();
    
    try {
      final data = {
        'name': student.name,
        'email': student.email,
        'age': student.age,
        'major': student.major,
      };

      final response = await _httpClient
          .patch(
            Uri.parse(_getApiUrl(student.id)),
            headers: _headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final updatedStudent = _parseStudentFromResponse(responseData);
        
        print('Student updated: ${updatedStudent.name} (${updatedStudent.id})');
        return updatedStudent;
      } else if (response.statusCode == 404) {
        throw DBAbstractionException(
          'Student with ID ${student.id} not found',
          operation: 'update',
        );
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'update',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to update student: ${student.name}',
        operation: 'update',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> delete(String id) async {
    _ensureInitialized();
    
    try {
      final response = await _httpClient
          .delete(
            Uri.parse(_getApiUrl(id)),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 204) {
        print('Student deleted: $id');
        return true;
      } else if (response.statusCode == 404) {
        print('Student not found for deletion: $id');
        return false;
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'delete',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to delete student with ID: $id',
        operation: 'delete',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Student>> getAll({String? majorFilter}) async {
    _ensureInitialized();
    
    try {
      Uri uri;
      
      if (majorFilter != null) {
        // Use PocketBase filter syntax
        uri = Uri.parse(_getApiUrl()).replace(
          queryParameters: {
            'filter': 'major = "$majorFilter"',
            'sort': 'name',
          },
        );
      } else {
        uri = Uri.parse(_getApiUrl()).replace(
          queryParameters: {
            'sort': 'name',
          },
        );
      }

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>;
        
        return items
            .map((item) => _parseStudentFromResponse(item as Map<String, dynamic>))
            .toList();
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'getAll',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to get all students',
        operation: 'getAll',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Student>> searchByName(String namePattern) async {
    _ensureInitialized();
    
    try {
      final uri = Uri.parse(_getApiUrl()).replace(
        queryParameters: {
          'filter': 'name ~ "$namePattern"', // PocketBase "contains" operator
          'sort': 'name',
        },
      );

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final items = data['items'] as List<dynamic>;
        
        return items
            .map((item) => _parseStudentFromResponse(item as Map<String, dynamic>))
            .toList();
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'searchByName',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to search students by name: $namePattern',
        operation: 'searchByName',
        originalError: e,
      );
    }
  }

  @override
  Future<int> count() async {
    _ensureInitialized();
    
    try {
      final uri = Uri.parse(_getApiUrl()).replace(
        queryParameters: {
          'perPage': '1', // We only need the count, not the data
        },
      );

      final response = await _httpClient
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['totalItems'] as int;
      } else {
        throw DBAbstractionException(
          'HTTP ${response.statusCode}: ${response.body}',
          operation: 'count',
        );
      }
    } catch (e) {
      if (e is DBAbstractionException) rethrow;
      throw DBAbstractionException(
        'Failed to count students',
        operation: 'count',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> clear() async {
    _ensureInitialized();
    
    try {
      // PocketBase doesn't have a bulk delete, so we need to get all records first
      final students = await getAll();
      
      // Delete each student individually
      for (final student in students) {
        await delete(student.id);
      }
      
      print('All students cleared from PocketBase database');
      return true;
    } catch (e) {
      throw DBAbstractionException(
        'Failed to clear all students',
        operation: 'clear',
        originalError: e,
      );
    }
  }

  @override
  Future<void> close() async {
    _httpClient.close();
    _isInitialized = false;
    print('PocketBase HTTP client closed');
  }
}
