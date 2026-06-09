import 'package:flutter/material.dart';

class CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final Color border;
  final VoidCallback onTap;
  const CircleBtn({
    required this.icon,
    required this.isDark,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.red.withValues(alpha: 0.3),
        color: Colors.black.withValues(alpha: 0.3),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Icon(icon, size: 14, color: Colors.white),
    ),
  );
}
