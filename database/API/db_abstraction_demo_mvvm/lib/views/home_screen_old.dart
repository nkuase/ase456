import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_viewmodel.dart';
import '../services/database_service_notifier.dart';
import '../services/database_service.dart';
import 'student_form_widget.dart';
import 'student_list_widget.dart';
import 'database_widgets.dart';

/// Simple Home Screen demonstrating MVVM coordination
///
/// Key MVVM concepts shown:
/// 1. Coordinator ViewModel manages child ViewModels
/// 2. Clear separation between View and ViewModel layers
/// 3. Data flows through ViewModels, not directly between Views
/// 4. UI automatically updates when ViewModel state changes
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();

    // Create ViewModel with dependency injection
    final databaseService =
        Provider.of<DatabaseServiceNotifier>(context, listen: false);
    _homeViewModel = HomeViewModel(databaseService);

    // Initialize ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeViewModel.initialize();
    });
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provide the HomeViewModel to child widgets
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _homeViewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MVVM Database Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // Database selector
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
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            if (homeViewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (homeViewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${homeViewModel.errorMessage}'),
                    ElevatedButton(
                      onPressed: () => homeViewModel.initialize(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Database status
                const DatabaseStatusWidget(),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Student Form (Left)
                        Expanded(
                          flex: 2,
                          child: ChangeNotifierProvider.value(
                            value: homeViewModel.formViewModel,
                            child: StudentFormWidget(
                              onStudentSaved: homeViewModel.onStudentSaved,
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Student List (Right)
                        Expanded(
                          flex: 3,
                          child: ChangeNotifierProvider.value(
                            value: homeViewModel.listViewModel,
                            child: StudentListWidget(
                              onEditStudent: homeViewModel.onEditStudent,
                              onDeleteStudent: homeViewModel.onDeleteStudent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
