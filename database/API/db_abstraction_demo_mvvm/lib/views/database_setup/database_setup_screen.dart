import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_notifier.dart';
import '../../services/database_service.dart';
import '../home/home_screen.dart';

/// Initial setup screen that helps users connect to a database
/// This demonstrates user onboarding and system initialization
class DatabaseSetupScreen extends StatefulWidget {
  const DatabaseSetupScreen({Key? key}) : super(key: key);

  @override
  State<DatabaseSetupScreen> createState() => _DatabaseSetupScreenState();
}

class _DatabaseSetupScreenState extends State<DatabaseSetupScreen> {
  bool _isChecking = true;
  Map<DatabaseType, bool> _availability = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkDatabaseAvailability();
  }

  /// Check which databases are available on this platform
  Future<void> _checkDatabaseAvailability() async {
    try {
      final dbServiceNotifier =
          Provider.of<DatabaseServiceNotifier>(context, listen: false);
      final availability = await dbServiceNotifier.getAvailableDatabases();

      setState(() {
        _availability = availability;
        _isChecking = false;
      });

      // Auto-connect to the first available database
      final availableTypes = availability.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (availableTypes.isNotEmpty) {
        await _connectToDatabase(availableTypes.first);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to check database availability: $e';
        _isChecking = false;
      });
    }
  }

  /// Connect to a specific database
  Future<void> _connectToDatabase(DatabaseType type) async {
    try {
      setState(() {
        _isChecking = true;
        _errorMessage = null;
      });

      final dbServiceNotifier =
          Provider.of<DatabaseServiceNotifier>(context, listen: false);
      final success = await dbServiceNotifier.switchDatabase(type);

      if (success) {
        // Navigate to main app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Failed to connect to ${_getDatabaseName(type)}';
          _isChecking = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to database: $e';
        _isChecking = false;
      });
    }
  }

  String _getDatabaseName(DatabaseType type) {
    switch (type) {
      case DatabaseType.sqlite:
        return 'SQLite';
      case DatabaseType.indexeddb:
        return 'IndexedDB';
      case DatabaseType.pocketbase:
        return 'PocketBase';
    }
  }

  String _getDatabaseDescription(DatabaseType type) {
    switch (type) {
      case DatabaseType.sqlite:
        return 'Local SQL database, perfect for mobile apps';
      case DatabaseType.indexeddb:
        return 'Browser-based NoSQL database for web applications';
      case DatabaseType.pocketbase:
        return 'Cloud-based backend with REST API (requires server)';
    }
  }

  IconData _getDatabaseIcon(DatabaseType type) {
    switch (type) {
      case DatabaseType.sqlite:
        return Icons.storage;
      case DatabaseType.indexeddb:
        return Icons.web;
      case DatabaseType.pocketbase:
        return Icons.cloud;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Abstraction Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Welcome message
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.school,
                        size: 64,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome to Database Abstraction Demo',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'This app demonstrates how to use interfaces to abstract database operations. '
                        'The same code works with different database implementations!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Database selection
              Text(
                'Choose a Database Implementation',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),

              if (_isChecking)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Checking database availability...'),
                    ],
                  ),
                )
              else if (_errorMessage != null)
                Center(
                  child: Card(
                    color: Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error,
                              color: Colors.red.shade700, size: 48),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _checkDatabaseAvailability,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: DatabaseType.values.map((type) {
                    final isAvailable = _availability[type] ?? false;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: isAvailable ? 4 : 1,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          _getDatabaseIcon(type),
                          size: 48,
                          color: isAvailable
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        title: Text(
                          _getDatabaseName(type),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isAvailable ? null : Colors.grey,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              _getDatabaseDescription(type),
                              style: TextStyle(
                                fontSize: 14,
                                color: isAvailable
                                    ? Colors.grey[600]
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isAvailable ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isAvailable ? 'Available' : 'Not Available',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: isAvailable
                            ? const Icon(Icons.arrow_forward,
                                color: Colors.green)
                            : const Icon(Icons.block, color: Colors.red),
                        onTap:
                            isAvailable ? () => _connectToDatabase(type) : null,
                        enabled: isAvailable,
                      ),
                    );
                  }).toList(),
                ),

              // Instructions
              if (!_isChecking && _errorMessage == null)
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(height: 8),
                        Text(
                          'Learning Objectives',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Understand interface-based programming\n'
                          '• See how the Strategy pattern works in practice\n'
                          '• Learn about different database technologies\n'
                          '• Experience dependency injection with Provider\n'
                          '• Practice CRUD operations across different systems',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
