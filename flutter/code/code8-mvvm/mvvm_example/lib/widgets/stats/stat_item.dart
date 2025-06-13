import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;
  final Color? valueColor;
  final Color? labelColor;
  final bool isVertical;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    this.onTap,
    this.valueColor,
    this.labelColor,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = isVertical ? _buildVerticalContent() : _buildHorizontalContent();
    
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: content,
        ),
      );
    }
    
    return content;
  }

  Widget _buildVerticalContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.statNumber.copyWith(
            color: valueColor ?? AppTextStyles.statNumber.color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.statLabel.copyWith(
            color: labelColor ?? AppTextStyles.statLabel.color,
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.statNumber.copyWith(
            color: valueColor ?? AppTextStyles.statNumber.color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.statLabel.copyWith(
            color: labelColor ?? AppTextStyles.statLabel.color,
          ),
        ),
      ],
    );
  }
} 