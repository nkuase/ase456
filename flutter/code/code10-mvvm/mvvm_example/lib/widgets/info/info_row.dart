import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

// Information row data class
class InfoRow {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final TextStyle? textStyle;
  final Widget? trailing;
  final VoidCallback? onTap;

  InfoRow({
    required this.icon,
    required this.text,
    this.iconColor,
    this.textStyle,
    this.trailing,
    this.onTap,
  });

  // Factory constructors (commonly used types)
  factory InfoRow.phone(String phoneNumber) {
    return InfoRow(
      icon: Icons.phone,
      text: phoneNumber,
      iconColor: AppColors.iconPhone,
    );
  }

  factory InfoRow.email(String email) {
    return InfoRow(
      icon: Icons.email,
      text: email,
      iconColor: AppColors.primary,
    );
  }

  factory InfoRow.location(String address) {
    return InfoRow(
      icon: Icons.location_on,
      text: address,
      iconColor: AppColors.iconLocation,
    );
  }

  factory InfoRow.birthday(String birthDate) {
    return InfoRow(
      icon: Icons.cake,
      text: birthDate,
      iconColor: AppColors.iconBirthday,
    );
  }

  factory InfoRow.website(String url) {
    return InfoRow(
      icon: Icons.language,
      text: url,
      iconColor: AppColors.primary,
    );
  }
} 