import 'package:flutter/material.dart';

class OfficeImagePlaceholder extends StatelessWidget {
  final Color muted;
  final bool isDark;
  final double iconSize;

  const OfficeImagePlaceholder({
    super.key,
    required this.muted,
    required this.isDark,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) => Container(
    color: isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.04),
    child: Center(
      child: Icon(Icons.home_work_outlined, size: iconSize, color: muted),
    ),
  );
}
