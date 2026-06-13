import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_card_compact.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_screen.dart';
import 'package:shimmer/shimmer.dart';

class PropertiesSection extends StatelessWidget {
  final bool isTablet;

  const PropertiesSection({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 48 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أحدث العقارات',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.lightTextSecondary
                            : AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تصفح أحدث العقارات المتاحة',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PropertiesScreen(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('عرض الكل'),
                      SizedBox(width: 8), // Optional spacing
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Properties Horizontal List
          BlocBuilder<PropertiesCubit, PropertiesState>(
            builder: (context, state) {
              if (state is PropertiesLoading) {
                return _PropertiesListLoading(
                  isDark: isDark,
                  isTablet: isTablet,
                );
              }

              if (state is PropertiesError) {
                debugPrint("===========================${state.message}");
                return Container(
                  height: isTablet ? 320 : 280,
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: isTablet ? 64 : 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: isTablet ? 16 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PropertiesCubit>().getProperties();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PropertiesSuccess) {
                final properties = state.propertiesResponse.properties;

                if (properties.isEmpty) {
                  return Container(
                    height: isTablet ? 320 : 280,
                    margin: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: isTablet ? 64 : 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد عقارات متاحة حالياً',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show first 10 properties
                final displayProperties = properties.take(10).toList();

                return Column(
                  children: [
                    // Horizontal scrolling list
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                      ),
                      child: Row(
                        children: displayProperties.map((property) {
                          return PropertyCardCompact(
                            property: property,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.propertyDetailsScreen,
                                arguments: property.id,
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // View All Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PropertiesScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_ios),
                          label: Text(
                            'عرض جميع العقارات (${state.propertiesResponse.meta.total})',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: AppColors.primary),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Properties List Loading Widget
// ─────────────────────────────────────────────────────────────────────────────

class _PropertiesListLoading extends StatelessWidget {
  final bool isDark;
  final bool isTablet;

  const _PropertiesListLoading({required this.isDark, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    final shimmerBase = isDark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFE0E0E0);
    final shimmerHighlight = isDark
        ? const Color(0xFF3C3C3E)
        : const Color(0xFFF5F5F5);

    return Column(
      children: [
        // Properties Cards Skeleton
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(
              3,
              (index) => _PropertyCardSkeleton(
                isDark: isDark,
                shimmerBase: shimmerBase,
                shimmerHighlight: shimmerHighlight,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // View All Button Skeleton
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _ShimmerBox(
            width: double.infinity,
            height: 40,
            radius: 8,
            base: shimmerBase,
            highlight: shimmerHighlight,
          ),
        ),
      ],
    );
  }
}

class _PropertyCardSkeleton extends StatelessWidget {
  final bool isDark;
  final Color shimmerBase, shimmerHighlight;

  const _PropertyCardSkeleton({
    required this.isDark,
    required this.shimmerBase,
    required this.shimmerHighlight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Skeleton
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                children: [
                  _ShimmerBox(
                    width: double.infinity,
                    height: double.infinity,
                    radius: 0,
                    base: shimmerBase,
                    highlight: shimmerHighlight,
                  ),
                  // Badge skeleton
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _ShimmerBox(
                      width: 60,
                      height: 24,
                      radius: 16,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Details Skeleton
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                _ShimmerBox(
                  width: double.infinity,
                  height: 14,
                  radius: 4,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
                const SizedBox(height: 6),
                _ShimmerBox(
                  width: 180,
                  height: 14,
                  radius: 4,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
                const SizedBox(height: 12),
                // Property Type
                Row(
                  children: [
                    _ShimmerBox(
                      width: 14,
                      height: 14,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                    const SizedBox(width: 4),
                    _ShimmerBox(
                      width: 80,
                      height: 12,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Location
                Row(
                  children: [
                    _ShimmerBox(
                      width: 14,
                      height: 14,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                    const SizedBox(width: 4),
                    _ShimmerBox(
                      width: 120,
                      height: 12,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Price and Views
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: 100,
                          height: 15,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 4),
                        _ShimmerBox(
                          width: 70,
                          height: 10,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                      ],
                    ),
                    _ShimmerBox(
                      width: 60,
                      height: 24,
                      radius: 12,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer Box Widget
// ─────────────────────────────────────────────────────────────────────────────

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final Color base;
  final Color highlight;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.base,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
