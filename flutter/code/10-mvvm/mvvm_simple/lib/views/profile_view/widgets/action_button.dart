// lib/views/profile_view/widgets/action_button.dart
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: onPressed == null ? 0 : 2,
      ),
    );
  }

  // Factory constructors for common button types
  factory ActionButton.load({
    required VoidCallback? onPressed,
  }) {
    return ActionButton(
      text: 'Load Profile',
      icon: Icons.download,
      color: Colors.blue,
      onPressed: onPressed,
    );
  }

  factory ActionButton.increaseAge({
    required VoidCallback? onPressed,
  }) {
    return ActionButton(
      text: 'Increase Age',
      icon: Icons.add,
      color: Colors.green,
      onPressed: onPressed,
    );
  }

  factory ActionButton.clear({
    required VoidCallback? onPressed,
  }) {
    return ActionButton(
      text: 'Clear Profile',
      icon: Icons.clear,
      color: Colors.red,
      onPressed: onPressed,
    );
  }

  factory ActionButton.reset({
    required VoidCallback? onPressed,
  }) {
    return ActionButton(
      text: 'Reset',
      icon: Icons.refresh,
      color: Colors.orange,
      onPressed: onPressed,
    );
  }
}