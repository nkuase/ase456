import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/models/student.dart';
import '../core/models/api_response.dart';
import '../core/utils/json_converter.dart';

/// HTTP client for communicating with the CRUD API server
/// This allows applications to interact with any database backend through a unified API
class CrudApiClient {
  final String baseUrl;
  final http.Client _httpClient;
  final Duration timeout;

  CrudApiClient({
    required this.baseUrl,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 30),
  }) : _httpClient = httpClient ?? http.Client();

  /// Dispose resources
  void dispose() {
    _httpClient.close();
  }

  // =============================================================================
  // HEALTH & STATUS
  // =============================================================================

  /// Check if the API server is healthy
  Future<bool> isHealthy() async {
    try {
      final response = await _get('/api/health');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => json as Map<String, dynamic>,
      );
      
      return apiResponse.success && 
             apiResponse.data?['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  /// Get database statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final response = await _get('/api/stats');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to get statistics');
    }
    
    return apiResponse.data!;
  }

  // =============================================================================
  // STUDENT CRUD OPERATIONS
  // =============================================================================

  /// Create a new student
  Future<Student> createStudent(Student student) async {
    final response = await _post('/api/students', student.toJson());
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to create student');
    }
    
    return Student.fromJson(apiResponse.data!);
  }

  /// Create multiple students in batch
  Future<BatchResponse> createStudentsBatch(List<Student> students) async {
    final studentsJson = students.map((s) => s.toJson()).toList();
    final response = await _post('/api/students/batch', studentsJson);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to create students batch');
    }
    
    return BatchResponse.fromJson(apiResponse.data!);
  }

  /// Get student by ID
  Future<Student?> getStudentById(String id) async {
    try {
      final response = await _get('/api/students/$id');
      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response,
        (json) => json as Map<String, dynamic>,
      );
      
      if (!apiResponse.success) {
        if (apiResponse.statusCode == 404) {
          return null; // Student not found
        }
        throw Exception(apiResponse.error ?? 'Failed to get student');
      }
      
      return Student.fromJson(apiResponse.data!);
    } catch (e) {
      if (e.toString().contains('404')) {
        return null;
      }
      rethrow;
    }
  }

  /// Get all students with optional query parameters
  Future<PaginatedResponse<Student>> getStudents([StudentQuery? query]) async {
    String url = '/api/students';
    
    if (query != null) {
      final queryParams = query.toQueryParams();
      if (queryParams.isNotEmpty) {
        final queryString = queryParams.entries
            .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
        url += '?$queryString';
      }
    }
    
    final response = await _get(url);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to get students');
    }
    
    return PaginatedResponse<Student>.fromJson(
      apiResponse.data!,
      (json) => Student.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Search students by text
  Future<List<Student>> searchStudents(String searchText) async {
    final url = '/api/search?q=${Uri.encodeComponent(searchText)}';
    final response = await _get(url);
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to search students');
    }
    
    return apiResponse.data!
        .map((json) => Student.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Update student
  Future<Student> updateStudent(String id, Student student) async {
    final response = await _put('/api/students/$id', student.toJson());
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to update student');
    }
    
    return Student.fromJson(apiResponse.data!);
  }

  /// Update specific fields of a student
  Future<Student> updateStudentFields(String id, Map<String, dynamic> fields) async {
    final response = await _patch('/api/students/$id', fields);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to update student fields');
    }
    
    return Student.fromJson(apiResponse.data!);
  }

  /// Delete student by ID
  Future<bool> deleteStudent(String id) async {
    final response = await _delete('/api/students/$id');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      if (apiResponse.statusCode == 404) {
        return false; // Student not found
      }
      throw Exception(apiResponse.error ?? 'Failed to delete student');
    }
    
    return apiResponse.data?['deleted'] == true;
  }

  /// Delete all students
  Future<int> deleteAllStudents() async {
    final response = await _delete('/api/students');
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to delete all students');
    }
    
    return apiResponse.data?['count'] as int? ?? 0;
  }

  // =============================================================================
  // EXPORT/IMPORT
  // =============================================================================

  /// Export all students to JSON format
  Future<List<Map<String, dynamic>>> exportStudents() async {
    final response = await _get('/api/export');
    final apiResponse = ApiResponse<List<dynamic>>.fromJson(
      response,
      (json) => json as List<dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to export students');
    }
    
    return apiResponse.data!.cast<Map<String, dynamic>>();
  }

  /// Import students from JSON format
  Future<BatchResponse> importStudents(List<Map<String, dynamic>> studentsJson) async {
    final response = await _post('/api/import', studentsJson);
    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response,
      (json) => json as Map<String, dynamic>,
    );
    
    if (!apiResponse.success) {
      throw Exception(apiResponse.error ?? 'Failed to import students');
    }
    
    return BatchResponse.fromJson(apiResponse.data!);
  }

  // =============================================================================
  // HTTP METHODS
  // =============================================================================

  /// Perform GET request
  Future<Map<String, dynamic>> _get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await _httpClient.get(url).timeout(timeout);
    return _handleResponse(response);
  }

  /// Perform POST request
  Future<Map<String, dynamic>> _post(String path, dynamic body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await _httpClient
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);
    return _handleResponse(response);
  }

  /// Perform PUT request
  Future<Map<String, dynamic>> _put(String path, dynamic body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await _httpClient
        .put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);
    return _handleResponse(response);
  }

  /// Perform PATCH request
  Future<Map<String, dynamic>> _patch(String path, dynamic body) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await _httpClient
        .patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        )
        .timeout(timeout);
    return _handleResponse(response);
  }

  /// Perform DELETE request
  Future<Map<String, dynamic>> _delete(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final response = await _httpClient.delete(url).timeout(timeout);
    return _handleResponse(response);
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw Exception('Empty response from server');
    }

    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return json;
    } catch (e) {
      throw Exception('Invalid JSON response: ${response.body}');
    }
  }
}

/// Convenience wrapper that implements the same interface as DatabaseService
/// but uses HTTP API calls instead of direct database access
class ApiDatabaseService {
  final CrudApiClient _client;

  ApiDatabaseService(String baseUrl) : _client = CrudApiClient(baseUrl: baseUrl);

  /// Dispose resources
  void dispose() {
    _client.dispose();
  }

  /// Create student
  Future<String> createStudent(Student student) async {
    final created = await _client.createStudent(student);
    return created.id!;
  }

  /// Get student by ID
  Future<Student?> getStudentById(String id) async {
    return await _client.getStudentById(id);
  }

  /// Get all students
  Future<List<Student>> getAllStudents([StudentQuery? query]) async {
    final result = await _client.getStudents(query);
    return result.items;
  }

  /// Search students
  Future<List<Student>> searchStudents(String searchText) async {
    return await _client.searchStudents(searchText);
  }

  /// Update student
  Future<bool> updateStudent(String id, Student student) async {
    try {
      await _client.updateStudent(id, student);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete student
  Future<bool> deleteStudent(String id) async {
    return await _client.deleteStudent(id);
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    return await _client.getStatistics();
  }

  /// Check health
  Future<bool> isHealthy() async {
    return await _client.isHealthy();
  }
}
