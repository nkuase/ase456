// Universal CRUD API Library
// Export all public interfaces and implementations

// Core interfaces and models
export 'core/interfaces/database_service.dart';
export 'core/models/student.dart';
export 'core/models/api_response.dart';
export 'core/utils/json_converter.dart';

// Database implementations
export 'implementations/sqlite_service.dart';
export 'implementations/pocketbase_service.dart';

// API server and client
export 'api/crud_api_server.dart';
export 'api/crud_api_client.dart';

// Examples
export 'examples/database_switching_example.dart';
export 'examples/api_server_example.dart';
export 'examples/api_client_example.dart';
