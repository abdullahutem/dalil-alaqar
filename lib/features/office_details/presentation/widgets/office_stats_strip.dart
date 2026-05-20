import 'package:flutter/material.dart';

class OfficeStatsStrip extends StatelessWidget {
  final List<({String value, String label})> items;
  final Color surface, border, muted, primary;

  const OfficeStatsStrip({
    super.key,
    required this.items,
    required this.surface,
    required this.border,
    required this.muted,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 1),
    decoration: BoxDecoration(
      color: surface,
      border: Border(
        top: BorderSide(color: border, width: 0.5),
        bottom: BorderSide(color: border, width: 0.5),
      ),
    ),
    child: IntrinsicHeight(
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              VerticalDivider(color: border, width: 0.5, thickness: 0.5),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      items[i].value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i].label,
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}
