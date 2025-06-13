import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../extensions/widget_extensions.dart';

class EditAvatarDialog extends StatefulWidget {
  final ProfileViewModel viewModel;

  const EditAvatarDialog({
    super.key,
    required this.viewModel,
  });

  static Future<void> show(BuildContext context, ProfileViewModel viewModel) {
    return showDialog(
      context: context,
      builder: (context) => EditAvatarDialog(viewModel: viewModel),
    );
  }

  @override
  State<EditAvatarDialog> createState() => _EditAvatarDialogState();
}

class _EditAvatarDialogState extends State<EditAvatarDialog> {
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    
    if (pickedFile != null) {
      await widget.viewModel.updateProfilePicture(pickedFile.path);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _updateProfilePictureFromUrl() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    // Validate URL format
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid URL starting with http:// or https://')),
        );
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.viewModel.updateProfilePicture(url);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load image: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Profile Picture'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'Image URL',
              hintText: 'Enter image URL',
              prefixIcon: Icon(Icons.link),
            ),
            keyboardType: TextInputType.url,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isLoading ? null : _updateProfilePictureFromUrl,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Update from URL'),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () => _pickImage(ImageSource.gallery, context),
          ),
          if (widget.viewModel.userModel.profilePicture != null)
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Photo'),
              onTap: () {
                widget.viewModel.removeProfilePicture();
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    ).paddingAll(8);
  }
} 