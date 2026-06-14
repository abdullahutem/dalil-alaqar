import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/presentation/widgets/office_image_placeholder.dart';
import 'package:flutter/material.dart';

class OfficePropertyCardTablet extends StatelessWidget {
  final RecentPropertyInfo property;
  final Color border, muted;
  final bool isDark;
  final String baseImageUrl;

  const OfficePropertyCardTablet({
    super.key,
    required this.property,
    required this.border,
    required this.muted,
    required this.isDark,
    required this.baseImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final cardBorder = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE5E5EA);
    final primary = isDark ? Colors.white : Colors.black;
    final secondary = isDark
        ? Colors.white.withValues(alpha: 0.55)
        : Colors.black.withValues(alpha: 0.5);

    final isForSale = property.offerType.name.contains('بيع');
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
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(13.5),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: property.primaryImage != null
                  ? CachedNetworkImage(
                      imageUrl:
                          '${EndPoints.kBaseImageUrl}${property.primaryImage!}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          OfficeImagePlaceholder(muted: muted, isDark: isDark),

                      errorWidget: (_, __, _) =>
                          OfficeImagePlaceholder(muted: muted, isDark: isDark),
                    )
                  : OfficeImagePlaceholder(muted: muted, isDark: isDark),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: offerBg,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: offerBorder, width: 0.5),
                      ),
                      child: Text(
                        property.offerType.name,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: offerFg,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        property.propertyType.name,
                        style: TextStyle(fontSize: 12, color: secondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: primary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  property.address,
                  style: TextStyle(fontSize: 12, color: secondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        property.price,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D9E75),
                        ),
                      ),
                    ),
                    Icon(Icons.remove_red_eye_outlined, size: 12, color: muted),
                    const SizedBox(width: 3),
                    Text(
                      property.viewsCount.toString(),
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                ),
                if (property.priceNegotiable) ...[
                  const SizedBox(height: 4),
                  Text(
                    'قابل للتفاوض',
                    style: TextStyle(fontSize: 11, color: muted),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
