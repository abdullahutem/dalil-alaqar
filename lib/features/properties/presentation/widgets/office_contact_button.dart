import 'package:flutter/material.dart';

class OfficeContactButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final Color border, muted, primary;
  final bool accent;
  final VoidCallback onTap;

  const OfficeContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.border,
    required this.muted,
    required this.primary,
    this.accent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = accent
        ? (isDark ? const Color(0xFF1A3326) : const Color(0xFFEAF3DE))
        : (isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04));
    final fg = accent
        ? (isDark ? const Color(0xFF5DCAA5) : const Color(0xFF0F6E56))
        : primary;
    final bc = accent
        ? (isDark ? const Color(0xFF2A5040) : const Color(0xFF9FE1CB))
        : border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: bc, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent
                    ? (isDark
                          ? const Color(0xFF2A5040)
                          : const Color(0xFFD4EFE5))
                    : (isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.05)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: fg),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 12, color: muted)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_back_ios_new_rounded, size: 13, color: muted),
          ],
        ),
      ),
    );
  }
}
