import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OfficeDetailsLoadingView extends StatelessWidget {
  const OfficeDetailsLoadingView({super.key});

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
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ShimmerBox(
                      width: double.infinity,
                      height: 20,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ShimmerBox(
                    width: 40,
                    height: 40,
                    radius: 20,
                    base: shimmerBase,
                    highlight: shimmerHighlight,
                  ),
                ],
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Header Card
                  _SkeletonCard(
                    surface: surface,
                    border: border,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Logo
                            _ShimmerBox(
                              width: 70,
                              height: 70,
                              radius: 12,
                              base: shimmerBase,
                              highlight: shimmerHighlight,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _ShimmerBox(
                                    width: double.infinity,
                                    height: 20,
                                    radius: 4,
                                    base: shimmerBase,
                                    highlight: shimmerHighlight,
                                  ),
                                  const SizedBox(height: 8),
                                  _ShimmerBox(
                                    width: 150,
                                    height: 14,
                                    radius: 4,
                                    base: shimmerBase,
                                    highlight: shimmerHighlight,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Padding(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: _ShimmerBox(
                                          width: 16,
                                          height: 16,
                                          radius: 8,
                                          base: shimmerBase,
                                          highlight: shimmerHighlight,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Chips row
                        Row(
                          children: List.generate(
                            3,
                            (index) => Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: _ShimmerBox(
                                width: 60,
                                height: 24,
                                radius: 12,
                                base: shimmerBase,
                                highlight: shimmerHighlight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Stats Strip
                  _SkeletonCard(
                    surface: surface,
                    border: border,
                    margin: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Expanded(
                          child: Row(
                            children: [
                              if (index > 0)
                                Container(
                                  width: 1,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  color: border,
                                ),
                              Expanded(
                                child: Column(
                                  children: [
                                    _ShimmerBox(
                                      width: 40,
                                      height: 40,
                                      radius: 10,
                                      base: shimmerBase,
                                      highlight: shimmerHighlight,
                                    ),
                                    const SizedBox(height: 8),
                                    _ShimmerBox(
                                      width: 60,
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
                        ),
                      ),
                    ),
                  ),

                  // About Section
                  _SkeletonCard(
                    surface: surface,
                    border: border,
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
                        const SizedBox(height: 12),
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
                          width: 200,
                          height: 14,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                      ],
                    ),
                  ),

                  // Contact Info Section
                  _SkeletonCard(
                    surface: surface,
                    border: border,
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
                                  width: 120,
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

                  // Recent Properties Section
                  _SkeletonCard(
                    surface: surface,
                    border: border,
                    margin: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: 120,
                          height: 16,
                          radius: 4,
                          base: shimmerBase,
                          highlight: shimmerHighlight,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: _PropertyCardSkeleton(
                                shimmerBase: shimmerBase,
                                shimmerHighlight: shimmerHighlight,
                                border: border,
                                surface: surface,
                              ),
                            ),
                          ),
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
  final Color surface, border;
  final EdgeInsets margin;
  final Widget child;

  const _SkeletonCard({
    required this.surface,
    required this.border,
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
        border: Border(bottom: BorderSide(color: border, width: 0.5)),
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

// ─────────────────────────────────────────────────────────────────────────────
// Property Card Skeleton Widget
// ─────────────────────────────────────────────────────────────────────────────

class _PropertyCardSkeleton extends StatelessWidget {
  final Color shimmerBase, shimmerHighlight, border, surface;

  const _PropertyCardSkeleton({
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.border,
    required this.surface,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          _ShimmerBox(
            width: 168,
            height: 110,
            radius: 13.5,
            base: shimmerBase,
            highlight: shimmerHighlight,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ShimmerBox(
                      width: 50,
                      height: 20,
                      radius: 6,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                    const SizedBox(width: 6),
                    _ShimmerBox(
                      width: 60,
                      height: 14,
                      radius: 4,
                      base: shimmerBase,
                      highlight: shimmerHighlight,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _ShimmerBox(
                  width: double.infinity,
                  height: 14,
                  radius: 4,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
                const SizedBox(height: 6),
                _ShimmerBox(
                  width: 120,
                  height: 14,
                  radius: 4,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
                const SizedBox(height: 8),
                _ShimmerBox(
                  width: 80,
                  height: 16,
                  radius: 4,
                  base: shimmerBase,
                  highlight: shimmerHighlight,
                ),
                const SizedBox(height: 6),
                _ShimmerBox(
                  width: 100,
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
    );
  }
}
