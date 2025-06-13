import 'package:flutter/material.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../extensions/widget_extensions.dart';

class EditProfileDialog extends StatefulWidget {
  final ProfileViewModel viewModel;

  const EditProfileDialog({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, ProfileViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (context) => EditProfileDialog(viewModel: viewModel),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.viewModel.userModel.name);
    _emailController = TextEditingController(text: widget.viewModel.userModel.email);
    _addressController = TextEditingController(text: widget.viewModel.userModel.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                icon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                icon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                icon: Icon(Icons.location_on),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            await widget.viewModel.updateProfile(
              name: _nameController.text,
              email: _emailController.text,
              address: _addressController.text,
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    ).paddingAll(8);
  }
} 