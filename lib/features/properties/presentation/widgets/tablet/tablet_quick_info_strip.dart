import 'package:flutter/material.dart';

class TabletQuickInfoStrip extends StatelessWidget {
  final List<({IconData icon, String label, String value})> items;
  final Color surface, border, muted, primary, secondary;
  final bool isDark;

  const TabletQuickInfoStrip({
    super.key,
    required this.items,
    required this.surface,
    required this.border,
    required this.muted,
    required this.primary,
    required this.secondary,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Row(
        children: items.map((item) {
          final isLast = item == items.last;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(item.icon, size: 20, color: muted),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.label,
                        style: TextStyle(fontSize: 11, color: muted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.value,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: primary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 1,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: border,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
