import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';

class PropertyListItem extends StatelessWidget {
  final RecentPropertyEntity property;

  const PropertyListItem({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);
    final muted = isDark
        ? Colors.white.withValues(alpha: 0.40)
        : Colors.black.withValues(alpha: 0.38);
    final secondary = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.5);
    final primary = isDark ? Colors.white : Colors.black;

    final isForSale = property.offerType.contains('بيع');
    final offerBg = isForSale
        ? const Color(0xFFEAF3DE)
        : const Color(0xFFE6F1FB);
    final offerFg = isForSale
        ? const Color(0xFF3B6D11)
        : const Color(0xFF185FA5);
    final offerBorder = isForSale
        ? const Color(0xFFC0DD97)
        : const Color(0xFFB5D4F4);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Thumbnail placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 52,
              height: 52,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.03),
              child: Icon(Icons.image_outlined, size: 24, color: muted),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: primary,
                    height: 1.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: offerBg,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: offerBorder, width: 0.5),
                      ),
                      child: Text(
                        property.offerType,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: offerFg,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        property.governorate,
                        style: TextStyle(fontSize: 11, color: secondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Price
          Text(
            _formatPrice(property.price),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D9E75),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String price) {
    // Simple formatting - you can enhance this
    return price;
  }
}
