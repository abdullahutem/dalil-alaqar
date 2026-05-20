import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PropertyLoadingView extends StatelessWidget {
  const PropertyLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final surface = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final shimmerBase = isDark
        ? const Color(0xFF2C2C2E)
        : const Color(0xFFE0E0E0);
    final shimmerHighlight = isDark
        ? const Color(0xFF3C3C3E)
        : const Color(0xFFF5F5F5);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: [
            // Image skeleton
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: surface,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  _ShimmerBox(
                    width: 40,
                    height: 40,
                    radius: 20,
                    base: shimmerBase,
                    highlight: shimmerHighlight,
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: _ShimmerBox(
                  width: double.infinity,
                  height: 300,
                  radius: 0,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Title & Price Card
                  _SkeletonCard(
                    surface: surface,
                    shimmerBase: shimmerBase,
                    shimmerHighlight: shimmerHighlight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badges row
                        Row(
                          children: [
                            _ShimmerBox(
                              width: 60,
                              height: 24,
                              radius: 12,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                            const SizedBox(width: 6),
                            _ShimmerBox(
                              width: 50,
                              height: 24,
                              radius: 12,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                            const Spacer(),
                            _ShimmerBox(
                              width: 40,
                              height: 16,
                              radius: 8,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Title
                        _ShimmerBox(
                          width: double.infinity,
                          height: 20,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 8),
                        _ShimmerBox(
                          width: 200,
                          height: 20,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 8),
                        // Location
                        _ShimmerBox(
                          width: 180,
                          height: 14,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 16),
                        // Price
                        _ShimmerBox(
                          width: 120,
                          height: 26,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                      ],
                    ),
                  ),

                  // Quick Info Strip
                  _SkeletonCard(
                    surface: surface,
                    shimmerBase: shimmerBase,
                    shimmerHighlight: shimmerHighlight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ShimmerBox(
                            width: double.infinity,
                            height: 60,
                            radius: 8,
                            base: shimmerBase,
                            highlight: shimmerHighlight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ShimmerBox(
                            width: double.infinity,
                            height: 60,
                            radius: 8,
                            base: shimmerBase,
                            highlight: shimmerHighlight,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _ShimmerBox(
                            width: double.infinity,
                            height: 60,
                            radius: 8,
                            base: shimmerBase,
                            highlight: shimmerHighlight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Description Card
                  _SkeletonCard(
                    surface: surface,
                    shimmerBase: shimmerBase,
                    shimmerHighlight: shimmerHighlight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: 80,
                          height: 16,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 10),
                        _ShimmerBox(
                          width: double.infinity,
                          height: 14,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 6),
                        _ShimmerBox(
                          width: double.infinity,
                          height: 14,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 6),
                        _ShimmerBox(
                          width: 250,
                          height: 14,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                      ],
                    ),
                  ),

                  // Location Card
                  _SkeletonCard(
                    surface: surface,
                    shimmerBase: shimmerBase,
                    shimmerHighlight: shimmerHighlight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _ShimmerBox(
                              width: 60,
                              height: 16,
                              radius: 4,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                            const Spacer(),
                            _ShimmerBox(
                              width: 34,
                              height: 34,
                              radius: 8,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          4,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                _ShimmerBox(
                                  width: 20,
                                  height: 20,
                                  radius: 4,
                                  base: shimmerBase,
                                  highlight: shimmerHighlight,
                                ),
                                const SizedBox(width: 12),
                                _ShimmerBox(
                                  width: 100,
                                  height: 14,
                                  radius: 4,
                                  base: shimmerBase,
                                  highlight: shimmerHighlight,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Office Card
                  _SkeletonCard(
                    surface: surface,
                    shimmerBase: shimmerBase,
                    shimmerHighlight: shimmerHighlight,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: 100,
                          height: 16,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _ShimmerBox(
                              width: 46,
                              height: 46,
                              radius: 12,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ShimmerBox(
                                    width: 150,
                                    height: 16,
                                    radius: 4,
                                    base: shimmerBase,
                                    highlight: shimmerHighlight,
                                  ),
                                  const SizedBox(height: 6),
                                  _ShimmerBox(
                                    width: 120,
                                    height: 12,
                                    radius: 4,
                                    base: shimmerBase,
                                    highlight: shimmerHighlight,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skeleton Card Widget
// ─────────────────────────────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  final Color surface;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final EdgeInsets margin;
  final Widget child;

  const _SkeletonCard({
    required this.surface,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.margin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        border: Border(
          bottom: BorderSide(
            color: shimmerBase.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: child,
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
