import 'package:flutter/material.dart';
import 'database_service.dart';
import '../models/student.dart';
import '../interfaces/database_interface.dart';

/// Wrapper class to make DatabaseService work with Provider
/// This allows the UI to react to database state changes
class DatabaseServiceNotifier extends ChangeNotifier {
  final DatabaseService _service = DatabaseService();
  
  DatabaseService get service => _service;
  
  // Expose commonly used properties and methods
  DatabaseType? get currentType => _service.currentType;
  bool get isConnected => _service.isConnected;
  DatabaseInterface? get currentDatabase => _service.currentDatabase;
  
  /// Proxy method that notifies listeners when database changes
  Future<bool> switchDatabase(DatabaseType type) async {
    final result = await _service.switchDatabase(type);
    notifyListeners(); // Tell UI to rebuild
    return result;
  }
  
  // Proxy all other methods to the service
  Future<Student> createStudent(Student student) async {
    final result = await _service.createStudent(student);
    notifyListeners();
    return result;
  }
  
  Future<Student?> getStudent(String id) => _service.getStudent(id);
  
  Future<Student> updateStudent(Student student) async {
    final result = await _service.updateStudent(student);
    notifyListeners();
    return result;
  }
  
  Future<bool> deleteStudent(String id) async {
    final result = await _service.deleteStudent(id);
    notifyListeners();
    return result;
  }
  
  Future<List<Student>> getAllStudents({String? majorFilter}) => 
      _service.getAllStudents(majorFilter: majorFilter);
  
  Future<List<Student>> searchStudents(String namePattern) => 
      _service.searchStudents(namePattern);
  
  Future<int> getStudentCount() => _service.getStudentCount();
  
  Future<bool> clearAllStudents() async {
    final result = await _service.clearAllStudents();
    notifyListeners();
    return result;
  }
  
  Future<Map<DatabaseType, bool>> getAvailableDatabases() => 
      _service.getAvailableDatabases();
  
  Future<Map<String, List<Student>>> getStudentsByMajor() => 
      _service.getStudentsByMajor();
  
  Future<Map<String, dynamic>> getStudentStatistics() => 
      _service.getStudentStatistics();
  
  String? validateStudent(Student student) => 
      _service.validateStudent(student);
  
  @override
  void dispose() {
    _service.close();
    super.dispose();
  }
}
