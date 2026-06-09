import 'package:flutter/material.dart';

class TabletActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final Color border, primary;
  final bool accent;
  final VoidCallback onTap;

  const TabletActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isDark,
    required this.border,
    required this.primary,
    this.accent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = accent
        ? (isDark ? const Color(0xFF1A3326) : const Color(0xFF1D9E75))
        : (isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.04));
    final fg = accent ? Colors.white : primary;
    final bc = accent
        ? (isDark ? const Color(0xFF2A5040) : const Color(0xFF1D9E75))
        : border;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: bc, width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: fg),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
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
