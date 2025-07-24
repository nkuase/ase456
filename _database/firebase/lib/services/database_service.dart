/// Abstract database interface for database abstraction pattern
/// This allows switching between different database implementations
/// (Firebase, PocketBase, SQLite, etc.) without changing application logic
abstract class DatabaseService {
  /// Create a new record with the given data
  /// Returns the ID of the created record
  Future<String> create(Map<String, dynamic> data);

  /// Read a record by its ID
  /// Returns null if the record doesn't exist
  Future<Map<String, dynamic>?> read(String id);

  /// Read all records with optional filtering and ordering
  Future<List<Map<String, dynamic>>> readAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  /// Read records matching a specific condition
  Future<List<Map<String, dynamic>>> readWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  /// Update a record by its ID
  /// Returns true if successful, false otherwise
  Future<bool> update(String id, Map<String, dynamic> data);

  /// Update specific fields of a record
  /// Returns true if successful, false otherwise
  Future<bool> updateFields(String id, Map<String, dynamic> fields);

  /// Delete a record by its ID
  /// Returns true if successful, false otherwise
  Future<bool> delete(String id);

  /// Delete multiple records matching a condition
  /// Returns the number of deleted records
  Future<int> deleteWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  });

  /// Create multiple records in a batch operation
  /// Returns the IDs of created records
  Future<List<String>> createBatch(List<Map<String, dynamic>> dataList);

  /// Get a real-time stream of all records
  Stream<List<Map<String, dynamic>>> streamAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  /// Get a real-time stream of a single record
  Stream<Map<String, dynamic>?> streamDocument(String id);

  /// Get a real-time stream of records matching a condition
  Stream<List<Map<String, dynamic>>> streamWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  /// Get statistics about the data
  Future<Map<String, dynamic>> getStatistics();

  /// Search records by a text query
  Future<List<Map<String, dynamic>>> searchByText(String query, {
    List<String>? searchFields,
    int? limit,
  });

  /// Count total number of records
  Future<int> count();

  /// Count records matching a condition
  Future<int> countWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  });

  /// Check if a record exists
  Future<bool> exists(String id);

  /// Get paginated results
  Future<List<Map<String, dynamic>>> getPaginated({
    int limit = 20,
    String? orderBy,
    bool descending = false,
    String? startAfter,
  });

  /// Clear all data (use with caution!)
  Future<bool> clearAll();

  /// Close any open connections
  Future<void> close();

  /// Get the name of the database implementation
  String get implementationName;

  /// Check if the database supports real-time features
  bool get supportsRealTime;

  /// Check if the database supports transactions
  bool get supportsTransactions;

  /// Check if the database supports offline mode
  bool get supportsOffline;
}

/// Generic repository pattern for type-safe database operations
/// This wraps the DatabaseService with type safety for specific models
abstract class Repository<T> {
  final DatabaseService _databaseService;
  final String collectionName;
  final T Function(Map<String, dynamic>) fromMap;
  final Map<String, dynamic> Function(T) toMap;

  Repository({
    required DatabaseService databaseService,
    required this.collectionName,
    required this.fromMap,
    required this.toMap,
  }) : _databaseService = databaseService;

  /// Create a new entity
  Future<String> create(T entity) async {
    final data = toMap(entity);
    return await _databaseService.create(data);
  }

  /// Read an entity by ID
  Future<T?> read(String id) async {
    final data = await _databaseService.read(id);
    if (data == null) return null;
    return fromMap(data);
  }

  /// Read all entities
  Future<List<T>> readAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    final dataList = await _databaseService.readAll(
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    );
    return dataList.map(fromMap).toList();
  }

  /// Read entities matching a condition
  Future<List<T>> readWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    final dataList = await _databaseService.readWhere(
      field: field,
      value: value,
      operator: operator,
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    );
    return dataList.map(fromMap).toList();
  }

  /// Update an entity
  Future<bool> update(String id, T entity) async {
    final data = toMap(entity);
    return await _databaseService.update(id, data);
  }

  /// Update specific fields
  Future<bool> updateFields(String id, Map<String, dynamic> fields) async {
    return await _databaseService.updateFields(id, fields);
  }

  /// Delete an entity
  Future<bool> delete(String id) async {
    return await _databaseService.delete(id);
  }

  /// Delete entities matching a condition
  Future<int> deleteWhere({
    required String field,
    required dynamic value,
    String operator = '==',
  }) async {
    return await _databaseService.deleteWhere(
      field: field,
      value: value,
      operator: operator,
    );
  }

  /// Create multiple entities in batch
  Future<List<String>> createBatch(List<T> entities) async {
    final dataList = entities.map(toMap).toList();
    return await _databaseService.createBatch(dataList);
  }

  /// Stream all entities
  Stream<List<T>> streamAll({
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    return _databaseService.streamAll(
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    ).map((dataList) => dataList.map(fromMap).toList());
  }

  /// Stream a single entity
  Stream<T?> streamDocument(String id) {
    return _databaseService.streamDocument(id).map((data) {
      if (data == null) return null;
      return fromMap(data);
    });
  }

  /// Stream entities matching a condition
  Stream<List<T>> streamWhere({
    required String field,
    required dynamic value,
    String operator = '==',
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    return _databaseService.streamWhere(
      field: field,
      value: value,
      operator: operator,
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    ).map((dataList) => dataList.map(fromMap).toList());
  }

  /// Count entities
  Future<int> count() async {
    return await _databaseService.count();
  }

  /// Check if entity exists
  Future<bool> exists(String id) async {
    return await _databaseService.exists(id);
  }

  /// Get database service implementation name
  String get implementationName => _databaseService.implementationName;

  /// Check capabilities
  bool get supportsRealTime => _databaseService.supportsRealTime;
  bool get supportsTransactions => _databaseService.supportsTransactions;
  bool get supportsOffline => _databaseService.supportsOffline;
}
