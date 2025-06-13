import 'package:flutter/material.dart';
import '../../models/student.dart';

/// Delete confirmation dialog component
/// 
/// Small, focused component for confirming student deletion.
class DeleteConfirmationDialog extends StatelessWidget {
  final Student student;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.student,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Delete'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Are you sure you want to delete this student?'),
          const SizedBox(height: 12),
          Card(
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(student.email),
                  Text('${student.major} • Age ${student.age}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This action cannot be undone.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  /// Static method to show the dialog
  static Future<void> show(
    BuildContext context,
    Student student,
    VoidCallback onConfirm,
  ) {
    return showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        student: student,
        onConfirm: onConfirm,
      ),
    );
  }
}
