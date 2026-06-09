import 'package:flutter/material.dart';

class BarBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final Color border, fg, bg;
  final VoidCallback onTap;

  const BarBtn({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.border,
    required this.fg,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: fg),
          const SizedBox(width: 7),
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
