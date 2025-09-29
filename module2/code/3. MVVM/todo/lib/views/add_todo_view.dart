import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/todo_viewmodel.dart';

/// View - Add Todo Screen
///
/// This screen demonstrates how Views should:
/// 1. Handle user input
/// 2. Validate data (UI-level validation)
/// 3. Call ViewModel methods to perform actions
/// 4. Not contain business logic
class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Todo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  hintText: 'Enter todo title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  if (value.trim().length < 3) {
                    return 'Title must be at least 3 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
              ),
              const SizedBox(height: 16),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter todo description (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 500,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveTodo,
                      child: const Text('Save Todo'),
                    ),
                  ),
                ],
              ),

              // Tips section
              const SizedBox(height: 32),
              _buildTipsSection(),
            ],
          ),
        ),
      ),
    );
  }

  /// Save todo - demonstrates how View interacts with ViewModel
  void _saveTodo() {
    if (_formKey.currentState?.validate() ?? false) {
      // Call ViewModel method - this is the key MVVM interaction
      context.read<TodoViewModel>().addTodo(
            _titleController.text,
            description: _descriptionController.text,
          );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop();
    }
  }

  /// Build tips section
  Widget _buildTipsSection() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Tips',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '• Write clear, actionable titles\n'
              '• Add descriptions for complex tasks\n'
              '• Break large tasks into smaller ones\n'
              '• Use specific, measurable goals',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
