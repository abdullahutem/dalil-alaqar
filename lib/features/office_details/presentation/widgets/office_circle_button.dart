import 'package:flutter/material.dart';

class OfficeCircleButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final Color border;
  final VoidCallback onTap;

  const OfficeCircleButton({
    super.key,
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
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.05),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Icon(icon, size: 15, color: isDark ? Colors.white : Colors.black),
    ),
  );
}
