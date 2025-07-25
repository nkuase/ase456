import 'database_crud.dart';

/// Factory class for creating database service instances
/// 
/// This class demonstrates the Factory Design Pattern, which is useful for:
/// - Creating objects without specifying exact classes
/// - Centralizing object creation logic
/// - Making it easier to switch between different implementations
/// - Facilitating dependency injection and testing
/// 
/// Educational Note: By removing static methods, we make this class:
/// - More testable (can be mocked)
/// - More flexible (can be configured differently)
/// - Following SOLID principles (especially Dependency Inversion)
class DatabaseServiceFactory {
  /// Private constructor to ensure controlled instantiation
  DatabaseServiceFactory._();
  
  /// Singleton instance for easy access throughout the app
  static final DatabaseServiceFactory _instance = DatabaseServiceFactory._();
  
  /// Get the singleton instance of the factory
  static DatabaseServiceFactory get instance => _instance;
  
  /// Configuration map to store different service types
  final Map<String, DatabaseCrudService Function()> _serviceCreators = {};
  
  /// Register a service creator function
  /// This allows for flexible service registration at runtime
  void registerService(String type, DatabaseCrudService Function() creator) {
    _serviceCreators[type] = creator;
  }
  
  /// Create a database service by type
  /// 
  /// Example usage:
  /// ```dart
  /// final factory = DatabaseServiceFactory.instance;
  /// final service = factory.createService('pocketbase');
  /// ```
  DatabaseCrudService createService(String type) {
    final creator = _serviceCreators[type];
    if (creator == null) {
      throw UnsupportedError('Database service type "$type" is not supported. '
          'Available types: ${_serviceCreators.keys.join(', ')}');
    }
    return creator();
  }
  
  /// Create a Firebase database service
  /// This method can be used when you specifically need Firebase
  DatabaseCrudService createFirebaseService() {
    return createService('firebase');
  }
  
  /// Create a PocketBase database service
  /// This method can be used when you specifically need PocketBase
  DatabaseCrudService createPocketBaseService() {
    return createService('pocketbase');
  }
  
  /// Create a SQLite database service
  /// This method can be used when you specifically need SQLite
  DatabaseCrudService createSQLiteService() {
    return createService('sqlite');
  }
  
  /// Get all available service types
  List<String> getAvailableServiceTypes() {
    return _serviceCreators.keys.toList();
  }
  
  /// Check if a service type is available
  bool hasService(String type) {
    return _serviceCreators.containsKey(type);
  }
  
  /// Clear all registered services (useful for testing)
  void clearServices() {
    _serviceCreators.clear();
  }
}

/// Example of how to initialize the factory with concrete implementations
/// 
/// This would typically be done in your main.dart or a configuration file:
/// ```dart
/// void initializeDatabaseFactory() {
///   final factory = DatabaseServiceFactory.instance;
///   
///   // Register concrete implementations
///   factory.registerService('pocketbase', () => PocketBaseStudentService());
///   factory.registerService('firebase', () => FirebaseStudentService());
///   factory.registerService('sqlite', () => SQLiteStudentService());
/// }
/// ```
/// 
/// Usage in your application:
/// ```dart
/// final factory = DatabaseServiceFactory.instance;
/// final dbService = factory.createService('pocketbase');
/// await dbService.initialize();
/// 
/// // Now you can use the service
/// final students = await dbService.getAllStudents();
/// ```
