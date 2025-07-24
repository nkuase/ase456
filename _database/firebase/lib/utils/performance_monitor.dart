import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Performance monitoring and optimization utilities for Firebase operations
class FirebasePerformanceMonitor {
  static final FirebasePerformanceMonitor _instance = FirebasePerformanceMonitor._internal();
  factory FirebasePerformanceMonitor() => _instance;
  FirebasePerformanceMonitor._internal();

  final List<OperationMetric> _metrics = [];
  final Map<String, int> _operationCounts = {};
  final Map<String, double> _averageTimes = {};

  /// Start monitoring an operation
  PerformanceTracker startOperation(String operationName) {
    return PerformanceTracker(operationName, this);
  }

  /// Record an operation metric
  void _recordMetric(OperationMetric metric) {
    _metrics.add(metric);
    
    // Update operation counts
    _operationCounts[metric.operationName] = 
        (_operationCounts[metric.operationName] ?? 0) + 1;
    
    // Update average times
    final currentAvg = _averageTimes[metric.operationName] ?? 0.0;
    final count = _operationCounts[metric.operationName]!;
    _averageTimes[metric.operationName] = 
        ((currentAvg * (count - 1)) + metric.durationMs) / count;
    
    // Log slow operations
    if (metric.durationMs > 1000) { // Slower than 1 second
      print('⚠️  Slow operation detected: ${metric.operationName} took ${metric.durationMs}ms');
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getStatistics() {
    return {
      'totalOperations': _metrics.length,
      'operationCounts': Map.from(_operationCounts),
      'averageTimes': Map.from(_averageTimes),
      'slowOperations': _metrics.where((m) => m.durationMs > 1000).length,
      'recentMetrics': _metrics.take(10).toList(),
    };
  }

  /// Print performance report
  void printReport() {
    print('📊 Firebase Performance Report');
    print('=' * 50);
    print('Total Operations: ${_metrics.length}');
    print('\nOperation Counts:');
    _operationCounts.forEach((operation, count) {
      final avgTime = _averageTimes[operation]?.toStringAsFixed(2) ?? '0';
      print('  $operation: $count operations (avg: ${avgTime}ms)');
    });
    
    final slowOps = _metrics.where((m) => m.durationMs > 1000).length;
    if (slowOps > 0) {
      print('\n⚠️  Slow Operations: $slowOps');
    }
    
    print('=' * 50);
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _operationCounts.clear();
    _averageTimes.clear();
  }
}

/// Individual operation tracker
class PerformanceTracker {
  final String operationName;
  final FirebasePerformanceMonitor monitor;
  final DateTime startTime;
  late DateTime endTime;
  bool _completed = false;

  PerformanceTracker(this.operationName, this.monitor) : startTime = DateTime.now();

  /// Stop tracking and record metric
  void stop({String? additionalInfo}) {
    if (_completed) return;
    
    endTime = DateTime.now();
    _completed = true;
    
    final metric = OperationMetric(
      operationName: operationName,
      startTime: startTime,
      endTime: endTime,
      durationMs: endTime.difference(startTime).inMilliseconds,
      additionalInfo: additionalInfo,
    );
    
    monitor._recordMetric(metric);
  }

  /// Get elapsed time in milliseconds
  int get elapsedMs => DateTime.now().difference(startTime).inMilliseconds;
}

/// Metric data structure
class OperationMetric {
  final String operationName;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMs;
  final String? additionalInfo;

  OperationMetric({
    required this.operationName,
    required this.startTime,
    required this.endTime,
    required this.durationMs,
    this.additionalInfo,
  });

  @override
  String toString() {
    return '$operationName: ${durationMs}ms${additionalInfo != null ? ' ($additionalInfo)' : ''}';
  }
}

/// Performance-aware Firebase operations wrapper
class PerformantFirebaseOperations {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebasePerformanceMonitor _monitor = FirebasePerformanceMonitor();

  /// Create document with performance tracking
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    final tracker = _monitor.startOperation('create_$collection');
    
    try {
      final docRef = await _firestore.collection(collection).add(data);
      tracker.stop(additionalInfo: 'Document ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Read document with performance tracking
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String documentId,
  ) async {
    final tracker = _monitor.startOperation('read_$collection');
    
    try {
      final doc = await _firestore.collection(collection).doc(documentId).get();
      final fromCache = doc.metadata.isFromCache;
      
      tracker.stop(additionalInfo: fromCache ? 'From cache' : 'From server');
      
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Query collection with performance tracking
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection, {
    String? whereField,
    dynamic whereValue,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    final tracker = _monitor.startOperation('query_$collection');
    
    try {
      Query query = _firestore.collection(collection);
      
      if (whereField != null && whereValue != null) {
        query = query.where(whereField, isEqualTo: whereValue);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      final fromCache = snapshot.metadata.isFromCache;
      
      tracker.stop(additionalInfo: 
        '${snapshot.docs.length} docs, ${fromCache ? 'cached' : 'server'}');
      
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Update document with performance tracking
  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final tracker = _monitor.startOperation('update_$collection');
    
    try {
      await _firestore.collection(collection).doc(documentId).update(data);
      tracker.stop();
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Delete document with performance tracking
  Future<void> deleteDocument(
    String collection,
    String documentId,
  ) async {
    final tracker = _monitor.startOperation('delete_$collection');
    
    try {
      await _firestore.collection(collection).doc(documentId).delete();
      tracker.stop();
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Batch operations with performance tracking
  Future<void> batchOperations(List<BatchOperation> operations) async {
    final tracker = _monitor.startOperation('batch_operations');
    
    try {
      final batch = _firestore.batch();
      
      for (final op in operations) {
        switch (op.type) {
          case BatchOperationType.create:
            final docRef = _firestore.collection(op.collection).doc();
            batch.set(docRef, op.data!);
            break;
          case BatchOperationType.update:
            final docRef = _firestore.collection(op.collection).doc(op.documentId);
            batch.update(docRef, op.data!);
            break;
          case BatchOperationType.delete:
            final docRef = _firestore.collection(op.collection).doc(op.documentId);
            batch.delete(docRef);
            break;
        }
      }
      
      await batch.commit();
      tracker.stop(additionalInfo: '${operations.length} operations');
    } catch (e) {
      tracker.stop(additionalInfo: 'Error: $e');
      rethrow;
    }
  }

  /// Get performance statistics
  Map<String, dynamic> getPerformanceStats() {
    return _monitor.getStatistics();
  }

  /// Print performance report
  void printPerformanceReport() {
    _monitor.printReport();
  }
}

/// Batch operation definition
class BatchOperation {
  final BatchOperationType type;
  final String collection;
  final String? documentId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collection,
    this.documentId,
    this.data,
  });

  factory BatchOperation.create(String collection, Map<String, dynamic> data) {
    return BatchOperation(
      type: BatchOperationType.create,
      collection: collection,
      data: data,
    );
  }

  factory BatchOperation.update(String collection, String documentId, Map<String, dynamic> data) {
    return BatchOperation(
      type: BatchOperationType.update,
      collection: collection,
      documentId: documentId,
      data: data,
    );
  }

  factory BatchOperation.delete(String collection, String documentId) {
    return BatchOperation(
      type: BatchOperationType.delete,
      collection: collection,
      documentId: documentId,
    );
  }
}

enum BatchOperationType { create, update, delete }

/// Firebase optimization utilities
class FirebaseOptimizer {
  /// Analyze query performance and suggest optimizations
  static Map<String, dynamic> analyzeQuery({
    required String collection,
    String? whereField,
    dynamic whereValue,
    String? orderBy,
    int? limit,
  }) {
    final suggestions = <String>[];
    final warnings = <String>[];
    
    // Check for missing indexes
    if (whereField != null && orderBy != null && whereField != orderBy) {
      suggestions.add('Consider creating a composite index for $whereField and $orderBy');
    }
    
    // Check for large result sets
    if (limit == null || limit > 50) {
      warnings.add('Query may return large result set. Consider adding limit.');
    }
    
    // Check for inequality filters
    if (whereField != null) {
      suggestions.add('Use equality filters when possible for better performance');
    }
    
    return {
      'suggestions': suggestions,
      'warnings': warnings,
      'estimatedPerformance': _estimateQueryPerformance(
        collection: collection,
        hasWhere: whereField != null,
        hasOrderBy: orderBy != null,
        hasLimit: limit != null,
      ),
    };
  }

  static String _estimateQueryPerformance({
    required String collection,
    required bool hasWhere,
    required bool hasOrderBy,
    required bool hasLimit,
  }) {
    if (hasWhere && hasOrderBy && hasLimit) {
      return 'Good - Uses filtering, ordering, and limiting';
    } else if (hasWhere && hasLimit) {
      return 'Fair - Uses filtering and limiting';
    } else if (hasLimit) {
      return 'Fair - Uses limiting only';
    } else {
      return 'Poor - No optimization applied';
    }
  }

  /// Optimize Firestore settings for performance
  static Future<void> optimizeFirestoreSettings() async {
    try {
      // Enable offline persistence
      await FirebaseFirestore.instance.enablePersistence();
      print('✅ Offline persistence enabled');
      
      // Configure cache size (100MB)
      FirebaseFirestore.instance.settings = const Settings(
        cacheSizeBytes: 100 * 1024 * 1024,
        persistenceEnabled: true,
      );
      print('✅ Firestore cache optimized');
      
    } catch (e) {
      print('⚠️  Firestore optimization failed: $e');
    }
  }

  /// Monitor real-time connection status
  static Stream<bool> monitorConnection() {
    return FirebaseFirestore.instance.snapshotsInSync().map((_) => true);
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    // This would require platform-specific implementation
    // For now, return placeholder data
    return {
      'cacheSize': '50MB',
      'hitRate': '85%',
      'missRate': '15%',
      'lastSync': DateTime.now().subtract(const Duration(minutes: 5)),
    };
  }
}

/// Performance testing utilities
class FirebasePerformanceTester {
  final PerformantFirebaseOperations _operations = PerformantFirebaseOperations();

  /// Run comprehensive performance tests
  Future<Map<String, dynamic>> runPerformanceTests() async {
    print('🧪 Running Firebase performance tests...');
    
    final results = <String, dynamic>{};
    
    // Test create operations
    results['createTest'] = await _testCreateOperations();
    
    // Test read operations  
    results['readTest'] = await _testReadOperations();
    
    // Test query operations
    results['queryTest'] = await _testQueryOperations();
    
    // Test batch operations
    results['batchTest'] = await _testBatchOperations();
    
    return results;
  }

  Future<Map<String, dynamic>> _testCreateOperations() async {
    print('  Testing create operations...');
    final stopwatch = Stopwatch()..start();
    
    const iterations = 10;
    for (int i = 0; i < iterations; i++) {
      await _operations.createDocument('test_students', {
        'name': 'Test Student $i',
        'age': 20 + i,
        'major': 'Computer Science',
        'testData': true,
      });
    }
    
    stopwatch.stop();
    
    return {
      'iterations': iterations,
      'totalTime': stopwatch.elapsedMilliseconds,
      'averageTime': stopwatch.elapsedMilliseconds / iterations,
    };
  }

  Future<Map<String, dynamic>> _testReadOperations() async {
    print('  Testing read operations...');
    
    // First, get some document IDs to read
    final docs = await _operations.queryCollection(
      'test_students',
      limit: 5,
    );
    
    if (docs.isEmpty) {
      return {'error': 'No test documents found'};
    }
    
    final stopwatch = Stopwatch()..start();
    
    for (final doc in docs) {
      await _operations.readDocument('test_students', doc['id']);
    }
    
    stopwatch.stop();
    
    return {
      'iterations': docs.length,
      'totalTime': stopwatch.elapsedMilliseconds,
      'averageTime': stopwatch.elapsedMilliseconds / docs.length,
    };
  }

  Future<Map<String, dynamic>> _testQueryOperations() async {
    print('  Testing query operations...');
    final stopwatch = Stopwatch()..start();
    
    // Test different query types
    await _operations.queryCollection('test_students');
    await _operations.queryCollection('test_students', limit: 10);
    await _operations.queryCollection('test_students', 
        whereField: 'major', whereValue: 'Computer Science');
    await _operations.queryCollection('test_students', 
        orderBy: 'age', limit: 5);
    
    stopwatch.stop();
    
    return {
      'queries': 4,
      'totalTime': stopwatch.elapsedMilliseconds,
      'averageTime': stopwatch.elapsedMilliseconds / 4,
    };
  }

  Future<Map<String, dynamic>> _testBatchOperations() async {
    print('  Testing batch operations...');
    final stopwatch = Stopwatch()..start();
    
    final operations = List.generate(5, (i) => 
      BatchOperation.create('test_students', {
        'name': 'Batch Student $i',
        'age': 25 + i,
        'major': 'Mathematics',
        'testData': true,
        'batch': true,
      })
    );
    
    await _operations.batchOperations(operations);
    
    stopwatch.stop();
    
    return {
      'operations': operations.length,
      'totalTime': stopwatch.elapsedMilliseconds,
      'averageTime': stopwatch.elapsedMilliseconds / operations.length,
    };
  }

  /// Clean up test data
  Future<void> cleanupTestData() async {
    print('🧹 Cleaning up test data...');
    
    final testDocs = await _operations.queryCollection(
      'test_students',
      whereField: 'testData',
      whereValue: true,
    );
    
    for (final doc in testDocs) {
      await _operations.deleteDocument('test_students', doc['id']);
    }
    
    print('✅ Test data cleaned up (${testDocs.length} documents)');
  }
}
