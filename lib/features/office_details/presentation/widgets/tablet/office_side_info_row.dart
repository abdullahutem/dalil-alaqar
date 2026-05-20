import 'package:flutter/material.dart';

class OfficeSideInfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color muted, border;
  final bool isDark, isLast;
  final VoidCallback? onTap;

  const OfficeSideInfoRow({
    super.key,
    required this.icon,
    required this.value,
    required this.muted,
    required this.isDark,
    required this.border,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? Colors.white : Colors.black;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: isLast
            ? null
            : BoxDecoration(
                border: Border(bottom: BorderSide(color: border, width: 0.5)),
              ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 15, color: muted),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: onTap != null ? const Color(0xFF1D9E75) : primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_back_ios_new_rounded, size: 11, color: muted),
          ],
        ),
      ),
    );
  }
}
