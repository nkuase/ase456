import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

// Online status badge
class OnlineBadge extends StatelessWidget {
  final double size;
  final bool isOnline;

  const OnlineBadge({
    super.key,
    this.size = 20,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOnline ? AppColors.success : AppColors.textSecondary,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
} 