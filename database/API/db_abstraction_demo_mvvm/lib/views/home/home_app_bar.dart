import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../services/database_service.dart';

/// App bar component for home screen
/// 
/// Simple component showing:
/// 1. App title
/// 2. Database selector menu
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('MVVM Database Demo'),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return PopupMenuButton<DatabaseType>(
              icon: const Icon(Icons.storage),
              tooltip: 'Switch Database',
              onSelected: (type) => viewModel.switchDatabase(type),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: DatabaseType.sqlite,
                  child: Text('SQLite'),
                ),
                const PopupMenuItem(
                  value: DatabaseType.indexeddb,
                  child: Text('IndexedDB'),
                ),
                const PopupMenuItem(
                  value: DatabaseType.pocketbase,
                  child: Text('PocketBase'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
