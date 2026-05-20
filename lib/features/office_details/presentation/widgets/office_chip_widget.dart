import 'package:flutter/material.dart';

class OfficeChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool accent;
  final Color border;

  const OfficeChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.accent = false,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = accent
        ? (isDark ? const Color(0xFF1A3326) : const Color(0xFFEAF3DE))
        : (isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04));
    final tc = accent
        ? (isDark ? const Color(0xFF5DCAA5) : const Color(0xFF3B6D11))
        : (isDark
              ? Colors.white.withValues(alpha: 0.65)
              : Colors.black.withValues(alpha: 0.55));
    final bc = accent
        ? (isDark ? const Color(0xFF2A5040) : const Color(0xFFC0DD97))
        : border;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: bc, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: tc),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tc,
            ),
          ),
        ],
      ),
    );
  }
}
