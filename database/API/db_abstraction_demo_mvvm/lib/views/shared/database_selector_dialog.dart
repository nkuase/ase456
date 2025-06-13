import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_notifier.dart';
import '../../services/database_service.dart';

/// Database selector dialog component
/// 
/// Small component for switching between database implementations.
class DatabaseSelectorDialog extends StatefulWidget {
  const DatabaseSelectorDialog({Key? key}) : super(key: key);

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

    if (mounted) {
      setState(() {
        _availability = availability;
        _isLoading = false;
      });
    }
  }

  Future<void> _switchDatabase(DatabaseType type) async {
    final dbServiceNotifier =
        Provider.of<DatabaseServiceNotifier>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final success = await dbServiceNotifier.switchDatabase(type);

    if (!mounted) return;

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
                    return _DatabaseOption(
                      type: type,
                      isAvailable: _availability?[type] ?? false,
                      isCurrent: _getCurrentType() == type,
                      onSwitch: () => _switchDatabase(type),
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

  DatabaseType? _getCurrentType() {
    return Provider.of<DatabaseServiceNotifier>(context, listen: false)
        .currentType;
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
}

/// Individual database option widget
class _DatabaseOption extends StatelessWidget {
  final DatabaseType type;
  final bool isAvailable;
  final bool isCurrent;
  final VoidCallback onSwitch;

  const _DatabaseOption({
    required this.type,
    required this.isAvailable,
    required this.isCurrent,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getIcon(),
          color: isAvailable ? Theme.of(context).primaryColor : Colors.grey,
        ),
        title: Text(_getName()),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_getDescription()),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(isAvailable ? 'Available' : 'Not Available',
                    isAvailable ? Colors.green : Colors.red),
                if (isCurrent) ...[
                  const SizedBox(width: 8),
                  _buildStatusChip('Current', Colors.blue),
                ],
              ],
            ),
          ],
        ),
        trailing: isAvailable && !isCurrent
            ? ElevatedButton(
                onPressed: onSwitch,
                child: const Text('Switch'),
              )
            : null,
        enabled: isAvailable && !isCurrent,
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getName() {
    switch (type) {
      case DatabaseType.sqlite:
        return 'SQLite';
      case DatabaseType.indexeddb:
        return 'IndexedDB';
      case DatabaseType.pocketbase:
        return 'PocketBase';
    }
  }

  String _getDescription() {
    switch (type) {
      case DatabaseType.sqlite:
        return 'Local SQL database for mobile/desktop';
      case DatabaseType.indexeddb:
        return 'Browser-based NoSQL storage';
      case DatabaseType.pocketbase:
        return 'Cloud backend with REST API';
    }
  }

  IconData _getIcon() {
    switch (type) {
      case DatabaseType.sqlite:
        return Icons.storage;
      case DatabaseType.indexeddb:
        return Icons.web;
      case DatabaseType.pocketbase:
        return Icons.cloud;
    }
  }
}
