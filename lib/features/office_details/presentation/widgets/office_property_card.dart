import 'package:flutter/material.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

class OfficePropertyCard extends StatelessWidget {
  final RecentPropertyInfo property;
  final Color border, muted;
  final bool isDark;
  final String baseImageUrl;
  final void Function()? onTap;

  const OfficePropertyCard({
    super.key,
    required this.property,
    required this.border,
    required this.muted,
    required this.isDark,
    required this.baseImageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final surface = isDark ? const Color(0xFF2C2C2E) : Colors.white;
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13.5),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: property.primaryImage != null
                    ? Image.network(
                        '$baseImageUrl${property.primaryImage!}',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, _) =>
                            _ImgPlaceholder(muted: muted, isDark: isDark),
                      )
                    : _ImgPlaceholder(muted: muted, isDark: isDark),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Offer type badge + property type
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: offerBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: offerBorder, width: 0.5),
                          ),
                          child: Text(
                            property.offerType.name,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: offerFg,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            property.propertyType.name,
                            style: TextStyle(fontSize: 10, color: secondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        property.title,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: primary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D9E75),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.remove_red_eye_outlined,
                          size: 11,
                          color: muted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          property.viewsCount.toString(),
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                        if (property.priceNegotiable) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'قابل للتفاوض',
                              style: TextStyle(fontSize: 10, color: muted),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImgPlaceholder extends StatelessWidget {
  final Color muted;
  final bool isDark;

  const _ImgPlaceholder({required this.muted, required this.isDark});

  @override
  Widget build(BuildContext context) => Container(
    color: isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.04),
    child: Center(
      child: Icon(Icons.home_work_outlined, size: 30, color: muted),
    ),
  );
}
