import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/localization/localized_helper.dart';
import '../../domain/entities/categories_entitiy.dart';

class CategoryCard extends StatefulWidget {
  final CategoryEntity category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final imageUrl = widget.category.thumbnailUrl ?? widget.category.imageUrl;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnim.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Big image on top ──────────────────────────────────
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image
                      imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.fill,
                              memCacheHeight: 400,
                              memCacheWidth: 400,
                              fadeInDuration: const Duration(milliseconds: 300),
                              fadeOutDuration: const Duration(
                                milliseconds: 100,
                              ),
                              placeholder: (context, url) => Container(
                                color: const Color(0xFFFFF3E0),
                                child: Center(
                                  child: Text(
                                    context.isArabic
                                        ? widget.category.nameAr
                                        : widget.category.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.white,
                                child: Center(
                                  child: Text(
                                    context.isArabic
                                        ? widget.category.nameAr
                                        : widget.category.name,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : _placeholderImage(),

                      // Soft gradient scrim at the bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 48,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.08),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Product count badge — top corner
                      Positioned(
                        top: 10,
                        // left: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            context.isArabic
                                ? '${widget.category.productsCount} صنف'
                                : '${widget.category.productsCount} items',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFFFFF3E0),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          width: 72,
          height: 72,
        ),
      ),
    );
  }
}
