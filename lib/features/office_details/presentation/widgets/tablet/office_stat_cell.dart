import 'package:flutter/material.dart';

class OfficeStatCell extends StatelessWidget {
  final String value, label;
  final Color primary, muted;

  const OfficeStatCell({
    super.key,
    required this.value,
    required this.label,
    required this.primary,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 12, color: muted)),
      ],
    ),
  );
}
