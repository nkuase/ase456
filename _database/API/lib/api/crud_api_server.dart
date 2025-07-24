import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:uuid/uuid.dart';

import '../core/interfaces/database_service.dart';
import '../core/models/student.dart';
import '../core/models/api_response.dart';
import '../core/utils/json_converter.dart';

/// RESTful API server that provides HTTP endpoints for CRUD operations
/// This allows any client (web, mobile, desktop) to interact with the database
class CrudApiServer {
  final DatabaseService _databaseService;
  final int _port;
  final String _host;
  HttpServer? _server;
  final Uuid _uuid = const Uuid();

  CrudApiServer({
    required DatabaseService databaseService,
    int port = 8080,
    String host = 'localhost',
  })  : _databaseService = databaseService,
        _port = port,
        _host = host;

  /// Start the API server
  Future<void> start() async {
    try {
      // Initialize database
      await _databaseService.initialize();
      
      // Create router and add routes
      final router = Router();
      _setupRoutes(router);
      
      // Create handler with CORS and logging middleware
      final handler = Pipeline()
          .addMiddleware(corsHeaders())
          .addMiddleware(logRequests())
          .addMiddleware(_errorHandler)
          .addHandler(router);
      
      // Start server
      _server = await serve(handler, _host, _port);
      
      print('🚀 CRUD API Server started');
      print('📍 URL: http://$_host:$_port');
      print('📚 Database: ${_databaseService.databaseType}');
      print('💡 Try: curl http://$_host:$_port/api/students');
      print('');
      print('Available endpoints:');
      print('  GET    /api/health          - Health check');
      print('  GET    /api/stats           - Database statistics');
      print('  GET    /api/students        - Get all students');
      print('  GET    /api/students/:id    - Get student by ID');
      print('  POST   /api/students        - Create new student');
      print('  POST   /api/students/batch  - Create multiple students');
      print('  PUT    /api/students/:id    - Update student');
      print('  PATCH  /api/students/:id    - Update student fields');
      print('  DELETE /api/students/:id    - Delete student');
      print('  DELETE /api/students        - Delete all students');
    } catch (e) {
      throw Exception('Failed to start API server: $e');
    }
  }

  /// Stop the API server
  Future<void> stop() async {
    try {
      await _server?.close();
      await _databaseService.close();
      print('🛑 API Server stopped');
    } catch (e) {
      print('❌ Error stopping server: $e');
    }
  }

  /// Setup all API routes
  void _setupRoutes(Router router) {
    // Health check endpoint
    router.get('/api/health', _handleHealthCheck);
    
    // Statistics endpoint
    router.get('/api/stats', _handleGetStats);
    
    // Student CRUD endpoints
    router.get('/api/students', _handleGetStudents);
    router.get('/api/students/<id>', _handleGetStudentById);
    router.post('/api/students', _handleCreateStudent);
    router.post('/api/students/batch', _handleCreateStudentsBatch);
    router.put('/api/students/<id>', _handleUpdateStudent);
    router.patch('/api/students/<id>', _handleUpdateStudentFields);
    router.delete('/api/students/<id>', _handleDeleteStudent);
    router.delete('/api/students', _handleDeleteAllStudents);
    
    // Search endpoint
    router.get('/api/search', _handleSearchStudents);
    
    // Export/Import endpoints
    router.get('/api/export', _handleExportStudents);
    router.post('/api/import', _handleImportStudents);
    
    // Catch-all for 404
    router.all('/<ignored|.*>', _handleNotFound);
  }

  /// Error handling middleware
  Middleware get _errorHandler {
    return (Handler innerHandler) {
      return (Request request) async {
        try {
          return await innerHandler(request);
        } catch (error, stackTrace) {
          print('❌ API Error: $error');
          print('Stack trace: $stackTrace');
          
          final requestId = _generateRequestId();
          
          if (error is ValidationException) {
            return _jsonResponse(
              ApiResponse.validationError(error.errors, requestId: requestId),
              statusCode: 400,
            );
          } else if (error is NotFoundException) {
            return _jsonResponse(
              ApiResponse.notFound(error.resource, requestId: requestId),
              statusCode: 404,
            );
          } else if (error is DatabaseException) {
            return _jsonResponse(
              ApiResponse.error(
                error.message,
                errorDetails: error.details,
                requestId: requestId,
              ),
              statusCode: 500,
            );
          } else {
            return _jsonResponse(
              ApiResponse.error(
                'Internal server error',
                errorDetails: error.toString(),
                requestId: requestId,
              ),
              statusCode: 500,
            );
          }
        }
      };
    };
  }

  /// Health check endpoint
  Future<Response> _handleHealthCheck(Request request) async {
    final isHealthy = await _databaseService.isHealthy();
    final status = isHealthy ? 'healthy' : 'unhealthy';
    final statusCode = isHealthy ? 200 : 503;
    
    final healthData = {
      'status': status,
      'database': _databaseService.databaseType,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return _jsonResponse(
      ApiResponse.success(healthData, requestId: _generateRequestId()),
      statusCode: statusCode,
    );
  }

  /// Get database statistics
  Future<Response> _handleGetStats(Request request) async {
    final stats = await _databaseService.getStudentStatistics();
    return _jsonResponse(
      ApiResponse.success(stats, requestId: _generateRequestId()),
    );
  }

  /// Get all students with optional filtering
  Future<Response> _handleGetStudents(Request request) async {
    final query = StudentQuery.fromQueryParams(request.url.queryParameters);
    final result = await _databaseService.getStudents(query);
    
    return _jsonResponse(
      ApiResponse.success(result, requestId: _generateRequestId()),
    );
  }

  /// Get student by ID
  Future<Response> _handleGetStudentById(Request request) async {
    final id = request.params['id']!;
    final student = await _databaseService.getStudentById(id);
    
    if (student == null) {
      throw NotFoundException('Student', id);
    }
    
    return _jsonResponse(
      ApiResponse.success(student, requestId: _generateRequestId()),
    );
  }

  /// Create new student
  Future<Response> _handleCreateStudent(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    
    if (!JsonConverter.isValidStudentJson(json)) {
      throw ValidationException(['Invalid student data format']);
    }
    
    final student = Student.fromJson(json);
    final id = await _databaseService.createStudent(student);
    
    final createdStudent = await _databaseService.getStudentById(id);
    
    return _jsonResponse(
      ApiResponse.success(createdStudent, requestId: _generateRequestId()),
      statusCode: 201,
    );
  }

  /// Create multiple students in batch
  Future<Response> _handleCreateStudentsBatch(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as List<dynamic>;
    
    final students = json.map((item) {
      if (item is! Map<String, dynamic>) {
        throw ValidationException(['Invalid student data format']);
      }
      if (!JsonConverter.isValidStudentJson(item)) {
        throw ValidationException(['Invalid student data: $item']);
      }
      return Student.fromJson(item);
    }).toList();
    
    final result = await _databaseService.createStudentsBatch(students);
    
    return _jsonResponse(
      ApiResponse.success(result, requestId: _generateRequestId()),
      statusCode: 201,
    );
  }

  /// Update student
  Future<Response> _handleUpdateStudent(Request request) async {
    final id = request.params['id']!;
    final body = await request.readAsString();
    final json = jsonDecode(body) as Map<String, dynamic>;
    
    if (!JsonConverter.isValidStudentJson(json)) {
      throw ValidationException(['Invalid student data format']);
    }
    
    final student = Student.fromJson(json);
    final success = await _databaseService.updateStudent(id, student);
    
    if (!success) {
      throw NotFoundException('Student', id);
    }
    
    final updatedStudent = await _databaseService.getStudentById(id);
    
    return _jsonResponse(
      ApiResponse.success(updatedStudent, requestId: _generateRequestId()),
    );
  }

  /// Update student fields
  Future<Response> _handleUpdateStudentFields(Request request) async {
    final id = request.params['id']!;
    final body = await request.readAsString();
    final fields = jsonDecode(body) as Map<String, dynamic>;
    
    final success = await _databaseService.updateStudentFields(id, fields);
    
    if (!success) {
      throw NotFoundException('Student', id);
    }
    
    final updatedStudent = await _databaseService.getStudentById(id);
    
    return _jsonResponse(
      ApiResponse.success(updatedStudent, requestId: _generateRequestId()),
    );
  }

  /// Delete student by ID
  Future<Response> _handleDeleteStudent(Request request) async {
    final id = request.params['id']!;
    final success = await _databaseService.deleteStudent(id);
    
    if (!success) {
      throw NotFoundException('Student', id);
    }
    
    return _jsonResponse(
      ApiResponse.success({'deleted': true, 'id': id}, requestId: _generateRequestId()),
    );
  }

  /// Delete all students
  Future<Response> _handleDeleteAllStudents(Request request) async {
    final deletedCount = await _databaseService.deleteAllStudents();
    
    return _jsonResponse(
      ApiResponse.success({
        'deleted': true,
        'count': deletedCount,
      }, requestId: _generateRequestId()),
    );
  }

  /// Search students
  Future<Response> _handleSearchStudents(Request request) async {
    final searchText = request.url.queryParameters['q'];
    
    if (searchText == null || searchText.isEmpty) {
      throw ValidationException(['Search query parameter "q" is required']);
    }
    
    final students = await _databaseService.searchStudents(searchText);
    
    return _jsonResponse(
      ApiResponse.success(students, requestId: _generateRequestId()),
    );
  }

  /// Export students to JSON
  Future<Response> _handleExportStudents(Request request) async {
    final students = await _databaseService.exportStudents();
    
    return _jsonResponse(
      ApiResponse.success(students, requestId: _generateRequestId()),
    );
  }

  /// Import students from JSON
  Future<Response> _handleImportStudents(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as List<dynamic>;
    
    final studentsJson = json.cast<Map<String, dynamic>>();
    final result = await _databaseService.importStudents(studentsJson);
    
    return _jsonResponse(
      ApiResponse.success(result, requestId: _generateRequestId()),
      statusCode: 201,
    );
  }

  /// Handle 404 Not Found
  Response _handleNotFound(Request request) {
    return _jsonResponse(
      ApiResponse.error(
        'Endpoint not found',
        errorDetails: 'The requested endpoint ${request.method} ${request.url.path} does not exist',
        requestId: _generateRequestId(),
      ),
      statusCode: 404,
    );
  }

  /// Create JSON response
  Response _jsonResponse(ApiResponse response, {int? statusCode}) {
    final responseJson = response.toJson((data) => data);
    final responseBody = JsonConverter.prettyPrintJson(responseJson);
    
    return Response(
      statusCode ?? response.statusCode ?? 200,
      body: responseBody,
      headers: {
        'content-type': 'application/json',
        'X-Request-ID': response.requestId ?? 'unknown',
      },
    );
  }

  /// Generate unique request ID for tracing
  String _generateRequestId() {
    return _uuid.v4();
  }
}
