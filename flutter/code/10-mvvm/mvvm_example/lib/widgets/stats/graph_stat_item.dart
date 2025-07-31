import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'stat_item.dart';

// Statistics item with graph
class GraphStatItem extends StatelessWidget {
  final String value;
  final String label;
  final double percentage;
  final Color? graphColor;
  final VoidCallback? onTap;

  const GraphStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.percentage,
    this.graphColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatItem(
          value: value,
          label: label,
          onTap: onTap,
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: AppColors.background,
          valueColor: AlwaysStoppedAnimation<Color>(
            graphColor ?? AppColors.primary,
          ),
        ),
      ],
    );
  }
} 