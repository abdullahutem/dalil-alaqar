import 'package:flutter/material.dart';

class OfficeFabButton extends StatelessWidget {
  final String heroTag;
  final IconData icon;
  final String tooltip;
  final bool isDark, accent;
  final VoidCallback onTap;

  const OfficeFabButton({
    super.key,
    required this.heroTag,
    required this.icon,
    required this.tooltip,
    required this.isDark,
    this.accent = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = accent
        ? (isDark ? const Color(0xFF1A3326) : const Color(0xFFEAF3DE))
        : (isDark ? const Color(0xFF2C2C2E) : Colors.white);
    final ic = accent
        ? (isDark ? const Color(0xFF5DCAA5) : const Color(0xFF0F6E56))
        : (isDark ? Colors.white : Colors.black);
    final bc = accent
        ? (isDark ? const Color(0xFF2A5040) : const Color(0xFF9FE1CB))
        : (isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.1));

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bg,
            border: Border.all(color: bc, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: ic),
        ),
      ),
    );
  }
}
