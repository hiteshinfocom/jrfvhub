import 'package:flutter/material.dart';

class ExpandIconWidget extends StatelessWidget {
  final bool expanded;
  final Color? color;
  final double size;

  const ExpandIconWidget({
    super.key,
    required this.expanded,
    this.color,
    this.size = 22,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: size,
        color: color ?? Colors.grey.shade700,
      ),
    );
  }
}