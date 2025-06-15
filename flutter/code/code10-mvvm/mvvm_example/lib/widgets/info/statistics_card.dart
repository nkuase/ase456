import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/widget_extensions.dart';
import '../stats/stat_item.dart';

// Special card types
class StatisticsCard extends StatelessWidget {
  final String title;
  final List<StatItem> stats;
  final void Function(String)? onStatTap;

  const StatisticsCard({
    super.key,
    required this.title,
    required this.stats,
    this.onStatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.map((stat) => _buildStatItem(stat)).toList(),
          ),
        ],
      ).paddingAll(16),
    );
  }

  Widget _buildStatItem(StatItem stat) {
    return InkWell(
      onTap: onStatTap != null ? () => onStatTap!(stat.label) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(stat.value, style: AppTextStyles.statNumber),
            const SizedBox(height: 4),
            Text(stat.label, style: AppTextStyles.statLabel),
          ],
        ),
      ),
    );
  }
} 