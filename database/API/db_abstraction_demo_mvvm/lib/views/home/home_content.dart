import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../student_form/student_form_widget.dart';
import '../student_list/student_list_widget.dart';
import '../shared/database_status_widget.dart';

/// Main content component for home screen
/// 
/// Layout component showing:
/// 1. Database status at top
/// 2. Two-column layout with form and list
class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, homeViewModel, child) {
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
    );
  }
}
