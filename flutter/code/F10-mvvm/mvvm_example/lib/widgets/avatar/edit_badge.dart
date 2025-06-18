import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

// Edit button badge
class EditBadge extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;

  const EditBadge({
    super.key,
    this.size = 30,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(
          Icons.edit,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
} 