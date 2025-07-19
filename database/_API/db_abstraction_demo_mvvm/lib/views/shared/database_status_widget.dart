import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service_notifier.dart';
import 'database_selector_dialog.dart';

/// Database status widget showing current connection
/// 
/// Small component displaying:
/// 1. Connection status
/// 2. Current database name
/// 3. Switch button
class DatabaseStatusWidget extends StatelessWidget {
  const DatabaseStatusWidget({Key? key}) : super(key: key);

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
                color: isConnected 
                    ? Colors.green.shade800 
                    : Colors.red.shade800,
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
