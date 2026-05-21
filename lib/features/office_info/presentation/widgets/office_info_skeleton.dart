import 'package:flutter/material.dart';

class OfficeInfoSkeleton extends StatefulWidget {
  final bool isTablet;

  const OfficeInfoSkeleton({super.key, this.isTablet = false});

  @override
  State<OfficeInfoSkeleton> createState() => _OfficeInfoSkeletonState();
}

class _OfficeInfoSkeletonState extends State<OfficeInfoSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return widget.isTablet
            ? _buildTabletSkeleton(context)
            : _buildMobileSkeleton(context);
      },
    );
  }

  Widget _buildMobileSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _shimmer(80, 80, circular: true),
                const SizedBox(height: 12),
                _shimmer(20, 160),
                const SizedBox(height: 8),
                _shimmer(14, 120),
                const SizedBox(height: 8),
                _shimmer(24, 80, radius: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Info card
          _buildInfoCardSkeleton(theme, rows: 4),
          const SizedBox(height: 16),
          // Social card
          _buildInfoCardSkeleton(theme, rows: 2),
          const SizedBox(height: 16),
          // Description card
          _buildDescriptionSkeleton(theme),
        ],
      ),
    );
  }

  Widget _buildTabletSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _shimmer(100, 100, circular: true),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmer(22, 200),
                          const SizedBox(height: 10),
                          _shimmer(14, 140),
                          const SizedBox(height: 10),
                          _shimmer(26, 80, radius: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInfoCardSkeleton(theme, rows: 4)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildInfoCardSkeleton(theme, rows: 3)),
                ],
              ),
              const SizedBox(height: 20),
              _buildDescriptionSkeleton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCardSkeleton(ThemeData theme, {required int rows}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(16, 100),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          for (int i = 0; i < rows; i++) ...[
            Row(
              children: [
                _shimmer(16, 16, circular: true),
                const SizedBox(width: 12),
                Expanded(child: _shimmer(14, double.infinity)),
              ],
            ),
            if (i < rows - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildDescriptionSkeleton(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmer(16, 80),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _shimmer(12, double.infinity),
          const SizedBox(height: 8),
          _shimmer(12, double.infinity),
          const SizedBox(height: 8),
          _shimmer(12, 200),
        ],
      ),
    );
  }

  Widget _shimmer(
    double height,
    double width, {
    bool circular = false,
    double radius = 6,
  }) {
    return Container(
      height: height,
      width: width == double.infinity ? null : width,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: _animation.value * 0.3),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(radius),
      ),
    );
  }
}
