import 'package:flutter/material.dart';

class QuickInfoStrip extends StatelessWidget {
  final List<({IconData icon, String label, String value})> items;
  final Color surface, border, muted, primary, secondary;
  final bool isDark;

  const QuickInfoStrip({
    required this.items,
    required this.surface,
    required this.border,
    required this.muted,
    required this.primary,
    required this.secondary,
    required this.isDark,
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
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                child: Column(
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
                      child: Icon(items[i].icon, size: 16, color: muted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      items[i].value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i].label,
                      style: TextStyle(fontSize: 10, color: muted),
                      textAlign: TextAlign.center,
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
