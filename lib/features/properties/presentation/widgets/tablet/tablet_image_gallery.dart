import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:flutter/material.dart';

class TabletImageGallery extends StatelessWidget {
  final List<PropertyImage> images;
  final PageController pageController;
  final int currentIndex;
  final Function(int) onPageChanged;
  final Color muted;
  final bool isDark;

  const TabletImageGallery({
    super.key,
    required this.images,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.muted,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (images.isNotEmpty)
          PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl:
                    '${EndPoints.kBaseImageUrl}${images[index].imagePath}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.03),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: muted,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.black.withValues(alpha: 0.03),
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                    color: muted,
                  ),
                ),
              );
            },
          )
        else
          Container(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 64,
                color: muted,
              ),
            ),
          ),
        // Image indicator
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  '${currentIndex + 1} / ${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
