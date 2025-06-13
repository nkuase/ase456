import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[200],
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    final displayUrl = imageUrl ?? UserModel.defaultProfilePicture;

    if (displayUrl.startsWith('file://')) {
      final file = File(displayUrl.replaceFirst('file://', ''));
      return ClipOval(
        child: Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.error_outline,
            size: size * 0.6,
            color: Colors.red,
          ),
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        displayUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.error_outline,
          size: size * 0.6,
          color: Colors.red,
        ),
      ),
    );
  }
} 