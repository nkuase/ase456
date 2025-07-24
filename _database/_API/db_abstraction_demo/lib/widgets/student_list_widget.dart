import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/database_service_notifier.dart';
import '../models/student.dart';

/// Widget for displaying and managing the list of students
/// This demonstrates list handling, search, and CRUD operations
class StudentListWidget extends StatefulWidget {
  final List<Student> students;
  final bool isLoading;
  final VoidCallback onRefresh;
  final Function(Student) onEditStudent;
  final Function(String) onDeleteStudent;
  final Function(String) onError;

  const StudentListWidget({
    Key? key,
    required this.students,
    required this.isLoading,
    required this.onRefresh,
    required this.onEditStudent,
    required this.onDeleteStudent,
    required this.onError,
  }) : super(key: key);

  @override
  State<StudentListWidget> createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
    widget.onRefresh();
  }

  Future<void> _clearAllStudents() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to delete ALL students? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final dbServiceNotifier = Provider.of<DatabaseServiceNotifier>(context, listen: false);
      await dbServiceNotifier.clearAllStudents();
      
      widget.onRefresh();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All students cleared!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      widget.onError('Failed to clear students: $e');
    }
  }

  Future<void> _showStudentStatistics() async {
    try {
      final dbServiceNotifier = Provider.of<DatabaseServiceNotifier>(context, listen: false);
      final stats = await dbServiceNotifier.getStudentStatistics();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Student Statistics'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Students: ${stats['total']}'),
                Text('Average Age: ${stats['averageAge']?.toStringAsFixed(1) ?? '0'}'),
                if (stats['oldestStudent'] != null)
                  Text('Oldest: ${stats['oldestStudent'].name} (${stats['oldestStudent'].age})'),
                if (stats['youngestStudent'] != null)
                  Text('Youngest: ${stats['youngestStudent'].name} (${stats['youngestStudent'].age})'),
                const SizedBox(height: 16),
                const Text('Students by Major:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...((stats['majorCounts'] as Map<String, int>).entries.map(
                  (entry) => Text('${entry.key}: ${entry.value}'),
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      widget.onError('Failed to load statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search and actions
            Row(
              children: [
                Text(
                  'Students (${widget.students.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name...',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _performSearch,
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: widget.onRefresh,
                  tooltip: 'Refresh',
                ),
                IconButton(
                  icon: const Icon(Icons.analytics),
                  onPressed: _showStudentStatistics,
                  tooltip: 'Statistics',
                ),
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: _clearAllStudents,
                  tooltip: 'Clear All',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Student list
            Expanded(
              child: widget.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : widget.students.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.school, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No students found',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Add some students to get started!',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: widget.students.length,
                          itemBuilder: (context, index) {
                            final student = widget.students[index];
                            return StudentListTile(
                              student: student,
                              onEdit: () => widget.onEditStudent(student),
                              onDelete: () => widget.onDeleteStudent(student.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual student list item
class StudentListTile extends StatelessWidget {
  final Student student;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const StudentListTile({
    Key? key,
    required this.student,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Future<void> _confirmDelete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📧 ${student.email}'),
            Text('🎓 ${student.major} • Age ${student.age}'),
            Text('📅 Added: ${student.createdAt.toString().split(' ')[0]}'),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
              tooltip: 'Edit Student',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context),
              tooltip: 'Delete Student',
            ),
          ],
        ),
      ),
    );
  }
}
