/*
 * IndexedDB CRUD Operations Tutorial
 * Demonstrates Create, Read, Update, Delete operations using Dart and IndexedDB
 * 
 * Learning Objectives:
 * 1. Understand how to initialize IndexedDB
 * 2. Learn CRUD operations with practical examples
 * 3. Handle asynchronous database operations
 * 4. Manage transactions and error handling
 */

import 'dart:js_interop';
import 'dart:js_util';
import 'package:web/web.dart' as web;
import 'package:indexed_db/indexed_db.dart' as idb;

// Database configuration constants
const String dbName = 'UniversityDB';
const String storeName = 'students';
const int dbVersion = 1;

// Global variables for database management
late idb.Database database;
late web.HTMLElement outputDiv;
late web.HTMLElement statusDiv;

void main() async {
  print('🎓 Starting IndexedDB CRUD Tutorial...');

  try {
    // Get HTML elements for interaction with proper casting
    final outputElement = web.document.getElementById('output') as web.HTMLElement?;
    final statusElement = web.document.getElementById('db-status') as web.HTMLElement?;
    
    if (outputElement == null || statusElement == null) {
      print('❌ Required HTML elements not found!');
      return;
    }
    
    outputDiv = outputElement;
    statusDiv = statusElement;
    
    // Clear initial content
    outputDiv.textContent = '';
    statusDiv.textContent = '';

    // Initialize the database
    await initializeDatabase();

    // Set up event listeners for UI interactions
    setupEventListeners();

    log('✅ Application initialized successfully!');
    log('👉 Use the interface above to perform CRUD operations');
    
  } catch (error) {
    print('❌ Failed to initialize application: $error');
  }
}
