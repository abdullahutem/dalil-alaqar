import 'package:flutter/material.dart';

class OfficeContentSection extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  final Color surface, border, muted;

  const OfficeContentSection({
    super.key,
    required this.title,
    required this.child,
    required this.surface,
    required this.border,
    required this.muted,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: border, width: 0.5),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: muted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 14),
        child,
      ],
    ),
  );
}
