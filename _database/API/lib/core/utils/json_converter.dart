import 'dart:convert';
import '../models/student.dart';

/// Utility class for JSON conversion and database-specific adaptations
class JsonConverter {
  /// Convert any value to JSON-safe format
  static dynamic toJsonSafe(dynamic value) {
    if (value == null) return null;
    
    if (value is DateTime) {
      return value.toIso8601String();
    }
    
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), toJsonSafe(val)));
    }
    
    if (value is List) {
      return value.map(toJsonSafe).toList();
    }
    
    // Primitive types (String, int, double, bool) are already JSON-safe
    return value;
  }

  /// Convert JSON to strongly typed value with fallback
  static T? fromJsonSafe<T>(dynamic json, T Function(dynamic) converter) {
    try {
      if (json == null) return null;
      return converter(json);
    } catch (e) {
      print('JSON conversion error: $e');
      return null;
    }
  }

  /// Parse DateTime from various string formats
  static DateTime? parseDateTime(dynamic value) {
    if (value == null) return null;
    
    if (value is DateTime) return value;
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        // Try common formats
        try {
          return DateTime.tryParse(value);
        } catch (e2) {
          print('Failed to parse DateTime: $value');
          return null;
        }
      }
    }
    
    return null;
  }

  /// Convert DateTime to ISO string for JSON storage
  static String? dateTimeToIsoString(DateTime? dateTime) {
    return dateTime?.toIso8601String();
  }

  /// Sanitize string input for database storage
  static String sanitizeString(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Validate and convert ID to string format
  static String normalizeId(dynamic id) {
    if (id == null) throw ArgumentError('ID cannot be null');
    return id.toString();
  }

  /// Convert database-specific data to universal Student format
  static Student adaptStudentFromDatabase(Map<String, dynamic> data, String databaseType) {
    // Normalize the data based on database type
    final normalizedData = Map<String, dynamic>.from(data);
    
    switch (databaseType.toLowerCase()) {
      case 'sqlite':
        // SQLite stores integer IDs
        if (normalizedData['id'] is int) {
          normalizedData['id'] = normalizedData['id'].toString();
        }
        break;
        
      case 'firebase':
        // Firebase has auto-generated string IDs and Timestamp objects
        if (normalizedData['createdAt'] != null) {
          // Handle Firebase Timestamp objects
          final createdAt = normalizedData['createdAt'];
          if (createdAt is Map && createdAt.containsKey('seconds')) {
            normalizedData['createdAt'] = DateTime.fromMillisecondsSinceEpoch(
              createdAt['seconds'] * 1000
            ).toIso8601String();
          }
        }
        if (normalizedData['updatedAt'] != null) {
          final updatedAt = normalizedData['updatedAt'];
          if (updatedAt is Map && updatedAt.containsKey('seconds')) {
            normalizedData['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(
              updatedAt['seconds'] * 1000
            ).toIso8601String();
          }
        }
        break;
        
      case 'pocketbase':
        // PocketBase has different field names
        if (normalizedData.containsKey('created')) {
          normalizedData['createdAt'] = normalizedData['created'];
          normalizedData.remove('created');
        }
        if (normalizedData.containsKey('updated')) {
          normalizedData['updatedAt'] = normalizedData['updated'];
          normalizedData.remove('updated');
        }
        break;
        
      case 'indexeddb':
        // IndexedDB stores JavaScript objects
        // Usually no special conversion needed
        break;
    }

    // Ensure timestamps are in ISO format
    if (normalizedData['createdAt'] != null) {
      final createdAt = parseDateTime(normalizedData['createdAt']);
      normalizedData['createdAt'] = dateTimeToIsoString(createdAt);
    }
    
    if (normalizedData['updatedAt'] != null) {
      final updatedAt = parseDateTime(normalizedData['updatedAt']);
      normalizedData['updatedAt'] = dateTimeToIsoString(updatedAt);
    }

    // Sanitize string fields
    if (normalizedData['name'] is String) {
      normalizedData['name'] = sanitizeString(normalizedData['name']);
    }
    
    if (normalizedData['major'] is String) {
      normalizedData['major'] = sanitizeString(normalizedData['major']);
    }

    return Student.fromJson(normalizedData);
  }

  /// Convert universal Student to database-specific format
  static Map<String, dynamic> adaptStudentToDatabase(Student student, String databaseType) {
    final data = student.toJson();
    
    switch (databaseType.toLowerCase()) {
      case 'sqlite':
        // SQLite doesn't need special timestamp handling
        // Remove null ID for creation
        if (data['id'] == null) {
          data.remove('id');
        }
        break;
        
      case 'firebase':
        // Firebase handles timestamps automatically with FieldValue.serverTimestamp()
        // Remove timestamps - they'll be set by Firebase
        data.remove('createdAt');
        data.remove('updatedAt');
        data.remove('id'); // Firebase auto-generates IDs
        break;
        
      case 'pocketbase':
        // PocketBase uses 'created' and 'updated' field names
        if (data.containsKey('createdAt')) {
          data['created'] = data['createdAt'];
          data.remove('createdAt');
        }
        if (data.containsKey('updatedAt')) {
          data['updated'] = data['updatedAt'];
          data.remove('updatedAt');
        }
        break;
        
      case 'indexeddb':
        // IndexedDB works with JavaScript objects
        // No special conversion needed
        break;
    }

    return data;
  }

  /// Pretty print JSON for debugging
  static String prettyPrintJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  /// Validate JSON structure for Student
  static bool isValidStudentJson(Map<String, dynamic> json) {
    try {
      // Check required fields
      if (!json.containsKey('name') || json['name'] is! String) {
        return false;
      }
      
      if (!json.containsKey('age') || json['age'] is! int) {
        return false;
      }
      
      if (!json.containsKey('major') || json['major'] is! String) {
        return false;
      }

      // Try to create Student object
      Student.fromJson(json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Convert query parameters to database-specific format
  static Map<String, dynamic> adaptQueryToDatabase(StudentQuery query, String databaseType) {
    final queryMap = <String, dynamic>{};
    
    if (query.nameContains != null) {
      queryMap['nameContains'] = query.nameContains;
    }
    
    if (query.major != null) {
      queryMap['major'] = query.major;
    }
    
    if (query.minAge != null) {
      queryMap['minAge'] = query.minAge;
    }
    
    if (query.maxAge != null) {
      queryMap['maxAge'] = query.maxAge;
    }
    
    if (query.sortBy != null) {
      queryMap['sortBy'] = query.sortBy;
    }
    
    queryMap['sortDescending'] = query.sortDescending;
    
    if (query.limit != null) {
      queryMap['limit'] = query.limit;
    }
    
    if (query.offset != null) {
      queryMap['offset'] = query.offset;
    }

    return queryMap;
  }

  /// Create sample student data for testing
  static List<Student> createSampleStudents() {
    return [
      const Student(
        name: 'Alice Johnson',
        age: 20,
        major: 'Computer Science',
      ),
      const Student(
        name: 'Bob Smith',
        age: 22,
        major: 'Mathematics',
      ),
      const Student(
        name: 'Carol Davis',
        age: 19,
        major: 'Physics',
      ),
      const Student(
        name: 'David Wilson',
        age: 21,
        major: 'Computer Science',
      ),
      const Student(
        name: 'Eva Martinez',
        age: 23,
        major: 'Chemistry',
      ),
    ];
  }
}
