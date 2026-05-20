import 'package:flutter/material.dart';

class PropertyBadgePill extends StatelessWidget {
  final String label;
  final Color bg, fg, borderColor;

  const PropertyBadgePill({
    super.key,
    required this.label,
    required this.bg,
    required this.fg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: borderColor, width: 0.5),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
    ),
  );
}
