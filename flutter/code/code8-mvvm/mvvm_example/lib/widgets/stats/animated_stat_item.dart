import 'package:flutter/material.dart';
import 'stat_item.dart';

// Animated statistics item
class AnimatedStatItem extends StatefulWidget {
  final String value;
  final String label;
  final Duration animationDuration;
  final VoidCallback? onTap;

  const AnimatedStatItem({
    super.key,
    required this.value,
    required this.label,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.onTap,
  });

  @override
  _AnimatedStatItemState createState() => _AnimatedStatItemState();
}

class _AnimatedStatItemState extends State<AnimatedStatItem> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Opacity(
              opacity: _animation.value,
              child: StatItem(
                value: widget.value,
                label: widget.label,
              ),
            ),
          );
        },
      ),
    );
  }
} 