import 'base_viewmodel.dart';
import '../models/student.dart';
import '../services/database_service_notifier.dart';

/// Simple ViewModel for Student List
///
/// This demonstrates core MVVM concepts:
/// 1. List state management
/// 2. CRUD operations
/// 3. Data loading and refreshing
/// 4. Simple search functionality
class StudentListViewModel extends BaseViewModel {
  final DatabaseServiceNotifier _databaseService;

  List<Student> _students = [];
  String _searchQuery = '';

  StudentListViewModel(this._databaseService);

  // Getters
  List<Student> get students {
    if (_searchQuery.isEmpty) {
      return _students;
    }
    return _students.where((student) {
      return student.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          student.email.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  int get studentCount => students.length;
  String get searchQuery => _searchQuery;
  bool get isEmpty => students.isEmpty;

  /// Load students from database
  Future<void> loadStudents() async {
    await handleAsync(() async {
      _students = await _databaseService.getAllStudents();
      return _students;
    });
  }

  /// Search students by name or email
  void searchStudents(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Delete a student
  Future<bool> deleteStudent(String studentId) async {
    return await handleAsync(() async {
          await _databaseService.deleteStudent(studentId);
          _students.removeWhere((student) => student.id == studentId);
          return true;
        }) ??
        false;
  }

  /// Clear all students
  Future<bool> clearAllStudents() async {
    return await handleAsync(() async {
          await _databaseService.clearAllStudents();
          _students.clear();
          return true;
        }) ??
        false;
  }

  /// Refresh the list
  Future<void> refresh() async {
    await loadStudents();
  }
}
