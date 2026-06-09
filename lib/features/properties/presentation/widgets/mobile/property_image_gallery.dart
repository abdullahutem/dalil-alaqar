import 'package:cached_network_image/cached_network_image.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:flutter/material.dart';

class PropertyImageGallery extends StatelessWidget {
  final List<PropertyImage> images;
  final PageController pageController;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;
  final bool isDark;
  final Color muted, border;
  final String baseUrl;

  const PropertyImageGallery({
    super.key,
    required this.images,
    required this.pageController,
    required this.currentIndex,
    required this.onPageChanged,
    required this.isDark,
    required this.muted,
    required this.border,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Container(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.04),
        child: Center(
          child: Opacity(
            opacity: 0.15,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              child: Image.asset("assets/images/logo.png", height: 80),
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Page view
        PageView.builder(
          controller: pageController,
          onPageChanged: onPageChanged,
          itemCount: images.length,
          itemBuilder: (ctx, i) => CachedNetworkImage(
            imageUrl: '$baseUrl${images[i].imagePath}',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
              child: Center(
                child: Opacity(
                  opacity: 0.15,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset("assets/images/logo.png", height: 80),
                  ),
                ),
              ),
            ),
            errorWidget: (_, __, _) => Container(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
              child: Center(
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
        ),

        // Gradient overlay (bottom)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Dot indicators
        if (images.length > 1)
          Positioned(
            bottom: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),

        // Image counter chip (top right)
        if (images.length > 1)
          Positioned(
            top: 80,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${currentIndex + 1} / ${images.length}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
