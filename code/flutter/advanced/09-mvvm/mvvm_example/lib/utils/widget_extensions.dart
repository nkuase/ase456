// lib/utils/widget_extensions.dart
import 'package:flutter/material.dart';

// Widget extensions
extension WidgetExtensions on Widget {
  // Add padding
  Widget paddingAll(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }
  
  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }
  
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }
  
  // Add margin
  Widget marginAll(double value) {
    return Container(
      margin: EdgeInsets.all(value),
      child: this,
    );
  }
  
  Widget marginSymmetric({double horizontal = 0, double vertical = 0}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      ),
      child: this,
    );
  }
  
  // Center alignment
  Widget centered() {
    return Center(child: this);
  }
  
  // Make clickable
  Widget onTap(VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }
  
  // Wrap in card
  Widget asCard({
    EdgeInsets? margin,
    EdgeInsets? padding,
    double? elevation,
  }) {
    return Card(
      margin: margin ?? const EdgeInsets.all(8),
      elevation: elevation ?? 2,
      child: paddingAll(padding != null ? 0 : 16),
    );
  }
  
  // Conditional display
  Widget showIf(bool condition) {
    return condition ? this : const SizedBox.shrink();
  }
  
  // Loading overlay
  Widget withLoading(bool isLoading) {
    return Stack(
      children: [
        this,
        if (isLoading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}

// Context extensions
extension ContextExtensions on BuildContext {
  // Media query shortcuts
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  
  // Navigation shortcuts
  void pop() => Navigator.of(this).pop();
  Future<T?> push<T>(Widget screen) => Navigator.of(this).push<T>(
    MaterialPageRoute(builder: (_) => screen),
  );
  Future<T?> pushReplacement<T>(Widget screen) => Navigator.of(this).pushReplacement<T, T>(
    MaterialPageRoute(builder: (_) => screen),
  );
  
  // Snackbar display
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  // Dialog display
  Future<T?> showCustomDialog<T>(Widget dialog) {
    return showDialog<T>(
      context: this,
      builder: (_) => dialog,
    );
  }
}