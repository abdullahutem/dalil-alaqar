import 'package:flutter/material.dart';

class PropertyInfoRow extends StatelessWidget {
  final IconData icon;
  final String label, value;
  final Color border, muted;
  final bool isDark, isLast;
  final VoidCallback? onTap;

  const PropertyInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.border,
    required this.muted,
    required this.isDark,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: border, width: 0.5)),
              ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: muted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 11, color: muted)),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: onTap != null ? const Color(0xFF1D9E75) : primary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: muted),
          ],
        ),
      ),
    );
  }
}
