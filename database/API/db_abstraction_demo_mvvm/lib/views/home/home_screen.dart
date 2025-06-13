import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../services/database_service_notifier.dart';
import 'home_app_bar.dart';
import 'home_content.dart';
import 'home_states.dart';

/// Main Home Screen demonstrating MVVM coordination
/// 
/// This screen coordinates ViewModels and displays appropriate states.
/// Small, focused file that delegates to smaller components.
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
    _initializeViewModel();
  }

  void _initializeViewModel() {
    final databaseService =
        Provider.of<DatabaseServiceNotifier>(context, listen: false);
    _homeViewModel = HomeViewModel(databaseService);
    
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
    return ChangeNotifierProvider<HomeViewModel>.value(
      value: _homeViewModel,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: Consumer<HomeViewModel>(
          builder: (context, homeViewModel, child) {
            if (homeViewModel.isLoading) {
              return const LoadingState();
            }

            if (homeViewModel.errorMessage != null) {
              return const ErrorState();
            }

            return const HomeContent();
          },
        ),
      ),
    );
  }
}
