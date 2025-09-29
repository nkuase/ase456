/// Professional File-Based Test Logger for Flutter Widget Tests
/// 
/// This logger writes debugging information to log files for easy review
/// and sharing. Logs are stored in the test/logs/ directory.
/// 
/// Usage:
///   1. Set TestLogger.enableDebugLogging = true for debugging
///   2. Use various log methods in your tests
///   3. Check test/logs/ folder for output files
///   4. Set TestLogger.enableDebugLogging = false for clean runs
/// 
/// Example:
/// ```dart
/// import '../utils/test_logger.dart';
/// 
/// testWidgets('my test', (tester) async {
///   TestLogger.section('Starting test');
///   TestLogger.logViewModelState(viewModel, 'After setup');
///   // ... test logic
/// });
/// ```

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';

/// File-based test logger for debugging widget tests
/// Creates timestamped log files in test/logs/ directory
class TestLogger {
  /// Toggle this flag to enable/disable all debug output
  static const bool enableDebugLogging = true; // ← 🔥 ENABLED for debugging
  
  /// Test name for log identification
  static const String _testName = 'TodoListViewTest';
  
  /// Current log file path
  static String? _currentLogFile;
  static String? _latestLogFile;
  
  /// Initialize logging with a new timestamped file
  static void _initializeLogging() {
    if (!enableDebugLogging) return;
    
    final now = DateTime.now();
    final timestamp = now.toIso8601String().replaceAll(':', '-').replaceAll('.', '-');
    
    // Create timestamped log file
    _currentLogFile = 'test/logs/test_run_$timestamp.log';
    _latestLogFile = 'test/logs/latest.log';
    
    // Ensure logs directory exists
    final logsDir = Directory('test/logs');
    if (!logsDir.existsSync()) {
      logsDir.createSync(recursive: true);
    }
    
    // Write initial header
    final header = '''
================================================================================
🧪 FLUTTER TEST DEBUG LOG
================================================================================
Test Suite: $_testName
Started: ${now.toIso8601String()}
Log File: $_currentLogFile
================================================================================

''';
    
    _writeToFile(header);
  }
  
  /// Write message to log file
  static void _writeToFile(String message) {
    if (!enableDebugLogging || _currentLogFile == null) return;
    
    try {
      // Write to timestamped log
      final file = File(_currentLogFile!);
      file.writeAsStringSync(message, mode: FileMode.append);
      
      // Also write to latest.log for easy access
      if (_latestLogFile != null) {
        final latestFile = File(_latestLogFile!);
        latestFile.writeAsStringSync(message, mode: FileMode.append);
      }
    } catch (e) {
      // Fallback to console if file writing fails
      print('⚠️ TestLogger file write error: $e');
      print(message);
    }
  }
  
  /// Log debug-level messages (detailed information)
  static void debug(String message) {
    if (!enableDebugLogging) return;
    
    if (_currentLogFile == null) {
      _initializeLogging();
    }
    
    final timestamp = DateTime.now().toIso8601String().substring(11, 23); // HH:MM:SS.mmm
    _writeToFile('[$timestamp] [DEBUG] $message\\n');
  }

  /// Log info-level messages (important information)
  static void info(String message) {
    if (!enableDebugLogging) return;
    
    if (_currentLogFile == null) {
      _initializeLogging();
    }
    
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    _writeToFile('[$timestamp] [INFO]  $message\\n');
  }

  /// Log section headers (highest priority, for test organization)
  static void section(String sectionName) {
    if (!enableDebugLogging) return;
    
    if (_currentLogFile == null) {
      _initializeLogging();
    }
    
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final separator = '=' * 60;
    _writeToFile('\\n[$timestamp] $separator\\n');
    _writeToFile('[$timestamp] 🚀 $sectionName\\n');
    _writeToFile('[$timestamp] $separator\\n');
  }

  /// Log error messages (for test failures and exceptions)
  static void error(String message) {
    if (!enableDebugLogging) return;
    
    if (_currentLogFile == null) {
      _initializeLogging();
    }
    
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    _writeToFile('[$timestamp] [ERROR] 🚨 $message\\n');
  }

  /// Log a list of todos with context
  static void logTodos(List<Todo> todos, String context) {
    if (!enableDebugLogging) return;
    
    section(context);
    info('Total todos: ${todos.length}');
    for (var i = 0; i < todos.length; i++) {
      final todo = todos[i];
      debug('  [$i] Todo: "${todo.title}", Completed: ${todo.isCompleted}, ID: ${todo.id}');
    }
  }

  /// Log widget finder results to see how many widgets match
  static void logWidgetFinderResults(Finder finder, String widgetName) {
    if (!enableDebugLogging) return;
    
    final count = finder.evaluate().length;
    debug('🔍 Found "$widgetName" widgets: $count');
    
    if (count == 0) {
      debug('  ⚠️  No widgets found for "$widgetName"');
    } else if (count > 1) {
      debug('  ⚠️  Multiple widgets found for "$widgetName" (expected 1)');
    } else {
      debug('  ✅ Exactly one widget found for "$widgetName"');
    }
  }

  /// Log all text widgets in the current widget tree
  static void logAllTextWidgets(WidgetTester tester, {String? filter}) {
    if (!enableDebugLogging) return;
    
    section('Widget Tree Analysis');
    final allTextWidgets = find.byType(Text);
    final totalCount = allTextWidgets.evaluate().length;
    info('All Text widgets found: $totalCount');
    
    int filteredCount = 0;
    for (var element in allTextWidgets.evaluate()) {
      final textWidget = element.widget as Text;
      final data = textWidget.data;
      if (data != null) {
        if (filter == null || data.toLowerCase().contains(filter.toLowerCase())) {
          debug('  📝 Text widget: "$data"');
          filteredCount++;
        }
      }
    }
    
    if (filter != null) {
      info('Filtered Text widgets (containing "$filter"): $filteredCount');
    }
  }

  /// Log complete ViewModel state for debugging
  static void logViewModelState(TodoViewModel viewModel, String context) {
    if (!enableDebugLogging) return;
    
    section(context);
    info('📊 ViewModel State Analysis:');
    info('  • Current filter: ${viewModel.currentFilter}');
    info('  • Search query: "${viewModel.searchQuery}"');
    info('  • Total todos: ${viewModel.totalTodos}');
    info('  • Completed todos: ${viewModel.completedTodos}');
    info('  • Pending todos: ${viewModel.pendingTodos}');
    info('  • Visible todos (after filtering): ${viewModel.todos.length}');
    
    // Log the actual visible todos
    if (viewModel.todos.isNotEmpty) {
      debug('📋 Visible todos:');
      for (var i = 0; i < viewModel.todos.length; i++) {
        final todo = viewModel.todos[i];
        final status = todo.isCompleted ? "✅" : "⏳";
        debug('    [$i] "${todo.title}" ($status) ID: ${todo.id}');
      }
    } else {
      debug('📭 No todos visible (empty list)');
    }
  }

  /// Log checkbox states in the widget tree
  static void logCheckboxStates(WidgetTester tester, String context) {
    if (!enableDebugLogging) return;
    
    section(context);
    final checkboxes = find.byType(Checkbox);
    final count = checkboxes.evaluate().length;
    info('Found $count checkbox(es)');
    
    for (var i = 0; i < count; i++) {
      final checkbox = tester.widgetList<Checkbox>(checkboxes).elementAt(i);
      final value = checkbox.value;
      
      // Handle nullable checkbox.value properly
      final stateText = value == null 
          ? "🔘 Null/Indeterminate" 
          : (value ? "☑️ Checked" : "☐ Unchecked");
      
      debug('  Checkbox[$i]: $stateText');
    }
  }

  /// Log test step with timestamp for performance debugging
  static void step(String stepName) {
    if (!enableDebugLogging) return;
    
    final timestamp = DateTime.now().toIso8601String();
    info('🔄 STEP: $stepName (at $timestamp)');
  }

  /// Log test assertion results
  static void assertion(String finderDescription, Matcher matcher, String description) {
    if (!enableDebugLogging) return;
    
    debug('🔍 ASSERTION: $finderDescription - $description');
    debug('   Expected: $matcher');
  }
  
  /// Close current log file and write summary
  static void finalize() {
    if (!enableDebugLogging || _currentLogFile == null) return;
    
    final summary = '''

================================================================================
📋 TEST LOG SUMMARY
================================================================================
Log completed: ${DateTime.now().toIso8601String()}
Log file: $_currentLogFile
Latest log: $_latestLogFile

💡 To review logs:
   • Open: $_currentLogFile
   • Or check: $_latestLogFile (always contains the most recent run)

🔧 To disable logging:
   • Set TestLogger.enableDebugLogging = false
================================================================================

''';
    
    _writeToFile(summary);
    
    // Reset for next test run
    _currentLogFile = null;
    _latestLogFile = null;
  }
}