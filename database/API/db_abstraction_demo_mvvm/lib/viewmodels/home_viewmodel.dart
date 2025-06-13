import 'base_viewmodel.dart';
import 'student_form_viewmodel.dart';
import 'student_list_viewmodel.dart';
import '../models/student.dart';
import '../services/database_service_notifier.dart';
import '../services/database_service.dart';

/// Simple Home ViewModel that coordinates other ViewModels
///
/// This demonstrates MVVM coordination:
/// 1. Managing child ViewModels
/// 2. Coordinating data flow between components
/// 3. Handling app-level state
class HomeViewModel extends BaseViewModel {
  final DatabaseServiceNotifier _databaseService;

  // Child ViewModels
  late final StudentFormViewModel formViewModel;
  late final StudentListViewModel listViewModel;

  HomeViewModel(this._databaseService) {
    formViewModel = StudentFormViewModel(_databaseService);
    listViewModel = StudentListViewModel(_databaseService);
  }

  /// Initialize the app
  Future<void> initialize() async {
    await listViewModel.loadStudents();
  }

  /// Handle student saved from form
  Future<void> onStudentSaved() async {
    await listViewModel.refresh();
  }

  /// Handle edit student request
  void onEditStudent(Student student) {
    formViewModel.setEditingStudent(student);
  }

  /// Handle delete student request
  Future<void> onDeleteStudent(String studentId) async {
    await listViewModel.deleteStudent(studentId);

    // Clear form if we were editing this student
    if (formViewModel.editingStudent?.id == studentId) {
      formViewModel.clearForm();
    }
  }

  /// Switch database
  Future<void> switchDatabase(DatabaseType type) async {
    await handleAsync(() async {
      await _databaseService.switchDatabase(type);
      await listViewModel.refresh();
      formViewModel.clearForm();
    });
  }

  @override
  void dispose() {
    formViewModel.dispose();
    listViewModel.dispose();
    super.dispose();
  }
}
