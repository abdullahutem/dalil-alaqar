import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/core/utils/price_formatter.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_entity.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/property_details_screen.dart';

class PropertyCard extends Widget {
  final PropertyEntity property;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.property, this.onTap});

  @override
  Element createElement() => _PropertyCardElement(this);

  String _formatPrice(String price) {
    return PriceFormatter.formatWithSeparators(price, locale: 'ar');
  }

  String _getCurrencySymbol() {
    return property.currency?.symbol ?? 'ريال';
  }

  String _getImageUrl() {
    if (property.primaryImage == null) {
      return '';
    }
    final imagePath = property.primaryImage!.imagePath;
    return imagePath.startsWith('http')
        ? imagePath
        : 'https://dalil-alaqar.codebrains.net/storage/$imagePath';
  }
}

class _PropertyCardElement extends ComponentElement {
  _PropertyCardElement(PropertyCard super.widget);

  @override
  PropertyCard get widget => super.widget as PropertyCard;

  @override
  Widget build() {
    final property = widget.property;
    final imageUrl = widget._getImageUrl();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap:
            widget.onTap ??
            () {
              Navigator.of(this).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PropertyDetailsScreen(propertyId: property.id),
                ),
              );
            },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Opacity(
                          opacity: 0.15,
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Opacity(
                          opacity: 0.15,
                          child: Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Offer Type Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        property.offerType.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Property Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Property Type
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property.propertyType.name,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${property.neighborhood.nameAr}، ${property.district.nameAr}، ${property.governorate.nameAr}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Price and Office
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget._formatPrice(property.price)} ${widget._getCurrencySymbol()}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (property.priceNegotiable)
                            Text(
                              'قابل للتفاوض',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      // Office
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            property.office.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.visibility_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${property.viewsCount}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
