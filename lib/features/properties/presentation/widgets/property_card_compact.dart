import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/image_cache_config.dart';
import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_entity.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/property_details_screen.dart';

class PropertyCardCompact extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback? onTap;

  const PropertyCardCompact({super.key, required this.property, this.onTap});

  String _formatPrice(String price) =>
      PriceFormatter.formatCompact(price, showDecimals: true);

  String _getCurrencySymbol() => property.currency?.symbol ?? 'ريال';

  String _getImageUrl() {
    if (property.primaryImage == null) return '';
    final path = property.primaryImage!.imagePath;
    return path.startsWith('http') ? path : '${EndPoints.kBaseImageUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getImageUrl();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap:
          onTap ??
          () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PropertyDetailsScreen(propertyId: property.id),
            ),
          ),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black12,
            width: 0.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: imageUrl.isNotEmpty
                        ? ImageCacheConfig.cachedImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.cover,
                          )
                        : ImageCacheConfig.defaultPlaceholder(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      property.offerType.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      property.propertyType.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Body
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 3),

                  // Location
                  _MetaRow(
                    icon: Icons.location_on_outlined,
                    label:
                        '${property.district.nameAr}، ${property.governorate.nameAr}',
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                  ),

                  // Price + Views
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_formatPrice(property.price)} ${_getCurrencySymbol()}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ),
                          if (property.priceNegotiable)
                            Text(
                              'قابل للتفاوض',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_outlined,
                            size: 14,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${property.viewsCount}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey[500]),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
