import 'package:flutter/material.dart';

class OfficeActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark, accent;
  final Color border;
  final VoidCallback onTap;

  const OfficeActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.border,
    required this.onTap,
    this.accent = false,
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
        : (isDark ? Colors.white : Colors.black);
    final bc = accent
        ? (isDark ? const Color(0xFF2A5040) : const Color(0xFF9FE1CB))
        : border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bc, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
