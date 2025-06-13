import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:db_abstraction_demo/services/database_service_notifier.dart';
import 'package:db_abstraction_demo/services/database_service.dart';

/// Widget that shows the current database connection status
/// This demonstrates how to display system state to users
class DatabaseStatusWidget extends StatelessWidget {
  const DatabaseStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseServiceNotifier>(
      builder: (context, dbServiceNotifier, child) {
        final isConnected = dbServiceNotifier.isConnected;
        final databaseName =
            dbServiceNotifier.currentDatabase?.databaseName ?? 'Unknown';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: isConnected ? Colors.green.shade100 : Colors.red.shade100,
          child: Row(
            children: [
              Icon(
                isConnected ? Icons.check_circle : Icons.error,
                color:
                    isConnected ? Colors.green.shade800 : Colors.red.shade800,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isConnected
                      ? 'Connected to: $databaseName'
                      : 'No database connected',
                  style: TextStyle(
                    color: isConnected
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isConnected)
                TextButton.icon(
                  onPressed: () => _showDatabaseSelector(context),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Switch'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green.shade800,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDatabaseSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DatabaseSelectorDialog(),
    );
  }
}

/// Dialog for selecting database implementation
class DatabaseSelectorDialog extends StatefulWidget {
  const DatabaseSelectorDialog({super.key});

  @override
  State<DatabaseSelectorDialog> createState() => _DatabaseSelectorDialogState();
}

class _DatabaseSelectorDialogState extends State<DatabaseSelectorDialog> {
  Map<DatabaseType, bool>? _availability;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final dbServiceNotifier =
        Provider.of<DatabaseServiceNotifier>(context, listen: false);
    final availability = await dbServiceNotifier.getAvailableDatabases();

    setState(() {
      _availability = availability;
      _isLoading = false;
    });
  }

  Future<void> _switchDatabase(DatabaseType type) async {
    final dbServiceNotifier =
        Provider.of<DatabaseServiceNotifier>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final success = await dbServiceNotifier.switchDatabase(type);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Switched to ${_getDatabaseName(type)}')),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to switch to ${_getDatabaseName(type)}'),
          backgroundColor: Colors.red,
        ),
      );
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
        return 'Local SQL database for mobile/desktop';
      case DatabaseType.indexeddb:
        return 'Browser-based NoSQL storage';
      case DatabaseType.pocketbase:
        return 'Cloud backend with REST API';
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
    return AlertDialog(
      title: const Text('Select Database'),
      content: _isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choose which database implementation to use:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ...DatabaseType.values.map((type) {
                    final isAvailable = _availability?[type] ?? false;
                    final isCurrent =
                        Provider.of<DatabaseServiceNotifier>(context)
                                .currentType ==
                            type;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _getDatabaseIcon(type),
                          color: isAvailable
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        title: Text(_getDatabaseName(type)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getDatabaseDescription(type)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color:
                                        isAvailable ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isAvailable ? 'Available' : 'Not Available',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (isCurrent) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Current',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        trailing: isAvailable && !isCurrent
                            ? ElevatedButton(
                                onPressed: () => _switchDatabase(type),
                                child: const Text('Switch'),
                              )
                            : null,
                        enabled: isAvailable && !isCurrent,
                      ),
                    );
                  }),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
