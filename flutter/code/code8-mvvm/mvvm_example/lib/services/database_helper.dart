import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:path/path.dart' as path;
import 'dart:convert';
import 'package:flutter/services.dart';

class DatabaseHelper {
  static const String _databaseName = "UserDatabase";
  static const int _databaseVersion = 1;
  static const String _userTableName = 'users';
  static const String _settingsTableName = 'settings';
  
  static DatabaseHelper? _instance;
  Database? _database;
  bool _isInitialized = false;

  DatabaseHelper._();

  static DatabaseHelper get instance {
    _instance ??= DatabaseHelper._();
    return _instance!;
  }

  Future<void> _printDatabaseStatus() async {
    final userTransaction = _database?.transaction(_userTableName, 'readonly');
    final settingsTransaction = _database?.transaction(_settingsTableName, 'readonly');
    if (userTransaction == null || settingsTransaction == null) return;

    try {
      final userStore = userTransaction.objectStore(_userTableName);
      final settingsStore = settingsTransaction.objectStore(_settingsTableName);
      final List<Map<String, dynamic>> users = [];
      final List<Map<String, dynamic>> settings = [];
      
      await for (final cursor in userStore.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      await for (final cursor in settingsStore.openCursor()) {
        if (cursor.value != null) {
          settings.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      print('\n=== Database Status ===');
      print('Database Name: $_databaseName');
      print('Version: $_databaseVersion');
      print('User Store: $_userTableName');
      print('Settings Store: $_settingsTableName');
      print('Number of Users: ${users.length}');
      print('Number of Settings: ${settings.length}');
      print('Initialized: $_isInitialized');
      print('=====================\n');
    } catch (e) {
      print('Error printing database status: $e');
    }
  }

  Future<void> initialize() async {
    if (_isInitialized && _database != null) {
      return;
    }

    try {
      final idbFactory = getIdbFactory();
      if (idbFactory == null) {
        throw Exception('IndexedDB is not supported in this environment');
      }

      _database = await idbFactory.open(
        _databaseName,
        version: _databaseVersion,
        onUpgradeNeeded: (VersionChangeEvent event) {
          final db = event.database;
          if (!db.objectStoreNames.contains(_userTableName)) {
            db.createObjectStore(
              _userTableName,
              keyPath: 'id',
              autoIncrement: true,
            );
          }
          if (!db.objectStoreNames.contains(_settingsTableName)) {
            db.createObjectStore(
              _settingsTableName,
              keyPath: 'id',
              autoIncrement: true,
            );
          }
        },
      );

      // Check if database is empty and initialize with default users if needed
      await _initializeDefaultUsers();
      await _initializeDefaultSettings();
      _isInitialized = true;
      
      await _printDatabaseStatus();
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _initializeDefaultUsers() async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) return;

    try {
      final store = transaction.objectStore(_userTableName);
      final List<Map<String, dynamic>> users = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      // If no users exist, add default users
      if (users.isEmpty) {
        print('Initializing database with default users...');
        final defaultUsers = [
          {
            'name': 'John Doe',
            'email': 'john.doe@example.com',
            'address': '123 Main St, City',
            'profilePicture': 'https://picsum.photos/200/200?random=1',
            'posts': 15,
            'followers': 120,
            'following': 45
          },
          {
            'name': 'Jane Smith',
            'email': 'jane.smith@example.com',
            'address': '456 Oak Ave, Town',
            'profilePicture': 'https://picsum.photos/200/200?random=2',
            'posts': 28,
            'followers': 350,
            'following': 120
          },
          {
            'name': 'Bob Johnson',
            'email': 'bob.johnson@example.com',
            'address': '789 Pine Rd, Village',
            'profilePicture': 'https://picsum.photos/200/200?random=3',
            'posts': 42,
            'followers': 890,
            'following': 230
          }
        ];

        final writeTransaction = _database?.transaction(_userTableName, 'readwrite');
        if (writeTransaction == null) return;
        
        final writeStore = writeTransaction.objectStore(_userTableName);
        for (final user in defaultUsers) {
          await writeStore.add(user);
        }
        
        print('Default users added successfully');
      }
    } catch (e) {
      print('Error initializing default users: $e');
      rethrow;
    }
  }

  Future<void> _initializeDefaultSettings() async {
    final transaction = _database?.transaction(_settingsTableName, 'readonly');
    if (transaction == null) return;

    try {
      final store = transaction.objectStore(_settingsTableName);
      final List<Map<String, dynamic>> settings = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          settings.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      // If no settings exist, add default settings
      if (settings.isEmpty) {
        print('Initializing database with default settings...');
        final defaultSettings = {
          'notificationsEnabled': true,
          'darkModeEnabled': false,
          'language': 'English'
        };

        final writeTransaction = _database?.transaction(_settingsTableName, 'readwrite');
        if (writeTransaction == null) return;
        
        final writeStore = writeTransaction.objectStore(_settingsTableName);
        final id = await writeStore.add(defaultSettings);
        print('Default settings added with ID: $id');
        
        print('Default settings added successfully');
      }
    } catch (e) {
      print('Error initializing default settings: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final transaction = _database?.transaction(_settingsTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_settingsTableName);
      final request = store.get(1); // Get the first settings record
      final result = await request.future;
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e) {
      print('Error getting settings: $e');
      rethrow;
    }
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    final transaction = _database?.transaction(_settingsTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_settingsTableName);
      await store.put(settings, 1); // Update the first settings record
      await _printDatabaseStatus();
    } catch (e) {
      print('Error updating settings: $e');
      rethrow;
    }
  }

  // User methods
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final List<Map<String, dynamic>> users = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }
      
      return users;
    } catch (e) {
      print('Error getting all users: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final request = store.get(id);
      final result = await request.future;
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  Future<int> addUser(Map<String, dynamic> user) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final id = await store.add(user);
      await _printDatabaseStatus();
      return id as int;
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      await store.put(user);
      await _printDatabaseStatus();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      await store.delete(id);
      await _printDatabaseStatus();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  void close() {
    if (_isInitialized && _database != null) {
      _database!.close();
      _database = null;
      _isInitialized = false;
    }
  }

  // Export database to JSON
  Future<String> exportDatabase() async {
    final users = await getAllUsers();
    final jsonString = jsonEncode(users);
    return base64Encode(utf8.encode(jsonString));
  }

  // Import database from JSON
  Future<void> importDatabase(String base64Data) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }
    
    // Clear existing data
    final store = transaction.objectStore(_userTableName);
    await store.clear();
    
    // Import new data
    final jsonString = utf8.decode(base64Decode(base64Data));
    final users = jsonDecode(jsonString) as List;
    for (final user in users) {
      await store.add(user as Map<String, dynamic>);
    }
  }

  Future<void> initialize() async {
    if (_isInitialized && _database != null) {
      return;
    }

    try {
      final idbFactory = getIdbFactory();
      if (idbFactory == null) {
        throw Exception('IndexedDB is not supported in this environment');
      }

      _database = await idbFactory.open(
        _databaseName,
        version: _databaseVersion,
        onUpgradeNeeded: (VersionChangeEvent event) {
          final db = event.database;
          if (!db.objectStoreNames.contains(_userTableName)) {
            db.createObjectStore(
              _userTableName,
              keyPath: 'id',
              autoIncrement: true,
            );
          }
          if (!db.objectStoreNames.contains(_settingsTableName)) {
            db.createObjectStore(
              _settingsTableName,
              keyPath: 'id',
              autoIncrement: true,
            );
          }
        },
      );

      // Check if database is empty and initialize with default users if needed
      await _initializeDefaultUsers();
      await _initializeDefaultSettings();
      _isInitialized = true;
      
      // Print database status
      await _printDatabaseStatus();
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _printDatabaseStatus() async {
    final userTransaction = _database?.transaction(_userTableName, 'readonly');
    final settingsTransaction = _database?.transaction(_settingsTableName, 'readonly');
    if (userTransaction == null || settingsTransaction == null) return;

    try {
      final userStore = userTransaction.objectStore(_userTableName);
      final settingsStore = settingsTransaction.objectStore(_settingsTableName);
      final List<Map<String, dynamic>> users = [];
      final List<Map<String, dynamic>> settings = [];
      
      await for (final cursor in userStore.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      await for (final cursor in settingsStore.openCursor()) {
        if (cursor.value != null) {
          settings.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      print('\n=== Database Status ===');
      print('Database Name: $_databaseName');
      print('Version: $_databaseVersion');
      print('User Store: $_userTableName');
      print('Settings Store: $_settingsTableName');
      print('Number of Users: ${users.length}');
      print('Number of Settings: ${settings.length}');
      print('Initialized: $_isInitialized');
      print('=====================\n');
    } catch (e) {
      print('Error printing database status: $e');
    }
  }

  Future<void> _initializeDefaultUsers() async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) return;

    try {
      final store = transaction.objectStore(_userTableName);
      final List<Map<String, dynamic>> users = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      // If no users exist, add default users
      if (users.isEmpty) {
        print('Initializing database with default users...');
        final defaultUsers = [
          {
            'name': 'John Doe',
            'email': 'john.doe@example.com',
            'address': '123 Main St, City',
            'profilePicture': 'https://picsum.photos/200/200?random=1',
            'posts': 15,
            'followers': 120,
            'following': 45
          },
          {
            'name': 'Jane Smith',
            'email': 'jane.smith@example.com',
            'address': '456 Oak Ave, Town',
            'profilePicture': 'https://picsum.photos/200/200?random=2',
            'posts': 28,
            'followers': 350,
            'following': 120
          },
          {
            'name': 'Bob Johnson',
            'email': 'bob.johnson@example.com',
            'address': '789 Pine Rd, Village',
            'profilePicture': 'https://picsum.photos/200/200?random=3',
            'posts': 42,
            'followers': 890,
            'following': 230
          }
        ];

        final writeTransaction = _database?.transaction(_userTableName, 'readwrite');
        if (writeTransaction == null) return;
        
        final writeStore = writeTransaction.objectStore(_userTableName);
        for (final user in defaultUsers) {
          await writeStore.add(user);
        }
        
        print('Default users added successfully');
      }
    } catch (e) {
      print('Error initializing default users: $e');
      rethrow;
    }
  }

  Future<void> _initializeDefaultSettings() async {
    final transaction = _database?.transaction(_settingsTableName, 'readonly');
    if (transaction == null) return;

    try {
      final store = transaction.objectStore(_settingsTableName);
      final List<Map<String, dynamic>> settings = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          settings.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }

      // If no settings exist, add default settings
      if (settings.isEmpty) {
        print('Initializing database with default settings...');
        final defaultSettings = {
          'notificationsEnabled': true,
          'darkModeEnabled': false,
          'language': 'English'
        };

        final writeTransaction = _database?.transaction(_settingsTableName, 'readwrite');
        if (writeTransaction == null) return;
        
        final writeStore = writeTransaction.objectStore(_settingsTableName);
        final id = await writeStore.add(defaultSettings);
        print('Default settings added with ID: $id');
        
        print('Default settings added successfully');
      }
    } catch (e) {
      print('Error initializing default settings: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getSettings() async {
    final transaction = _database?.transaction(_settingsTableName, 'readonly');
    if (transaction == null) return null;

    try {
      final store = transaction.objectStore(_settingsTableName);
      final request = store.get(1); // Get the first (and only) settings record
      final result = await request.future;
      
      if (result != null) {
        return Map<String, dynamic>.from(result);
      }
      return null;
    } catch (e) {
      print('Error getting settings: $e');
      return null;
    }
  }

  // User methods
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final List<Map<String, dynamic>> users = [];
      
      await for (final cursor in store.openCursor()) {
        if (cursor.value != null) {
          users.add(Map<String, dynamic>.from(cursor.value as Map));
        }
      }
      
      return users;
    } catch (e) {
      print('Error getting all users: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final transaction = _database?.transaction(_userTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final user = await store.getObject(id);
      return user != null ? Map<String, dynamic>.from(user as Map) : null;
    } catch (e) {
      print('Error getting user by ID: $e');
      rethrow;
    }
  }

  Future<int> addUser(Map<String, dynamic> user) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      final id = await store.add(user);
      await _printDatabaseStatus();
      return id as int;
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      await store.put(user);
      await _printDatabaseStatus();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  Future<void> deleteUser(int id) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_userTableName);
      await store.delete(id);
      await _printDatabaseStatus();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Settings methods
  Future<Map<String, dynamic>?> getSettings() async {
    final transaction = _database?.transaction(_settingsTableName, 'readonly');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_settingsTableName);
      final request = store.get(1); // Get the first settings record
      final result = await request.future;
      return result != null ? Map<String, dynamic>.from(result) : null;
    } catch (e) {
      print('Error getting settings: $e');
      rethrow;
    }
  }

  Future<void> updateSettings(Map<String, dynamic> settings) async {
    final transaction = _database?.transaction(_settingsTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }

    try {
      final store = transaction.objectStore(_settingsTableName);
      await store.put(settings, 1); // Update the first settings record
      await _printDatabaseStatus();
    } catch (e) {
      print('Error updating settings: $e');
      rethrow;
    }
  }

  void close() {
    if (_isInitialized && _database != null) {
      _database!.close();
      _database = null;
      _isInitialized = false;
    }
  }

  // Export database to JSON
  Future<String> exportDatabase() async {
    final users = await getAllUsers();
    final jsonString = jsonEncode(users);
    return base64Encode(utf8.encode(jsonString));
  }

  // Import database from JSON
  Future<void> importDatabase(String base64Data) async {
    final transaction = _database?.transaction(_userTableName, 'readwrite');
    if (transaction == null) {
      throw Exception('Database not initialized');
    }
    
    // Clear existing data
    final store = transaction.objectStore(_userTableName);
    await store.clear();
    
    // Import new data
    final jsonString = utf8.decode(base64Decode(base64Data));
    final users = jsonDecode(jsonString) as List;
    for (final user in users) {
      await store.add(user as Map<String, dynamic>);
    }
  }
} 