import 'package:flutter/material.dart';

class OfficePropertiesSkeleton extends StatefulWidget {
  final bool isTablet;
  const OfficePropertiesSkeleton({super.key, this.isTablet = false});

  @override
  State<OfficePropertiesSkeleton> createState() =>
      _OfficePropertiesSkeletonState();
}

class _OfficePropertiesSkeletonState extends State<OfficePropertiesSkeleton>
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
      builder: (context, _) => _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: widget.isTablet
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _shimmer(double.infinity, double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(16, double.infinity),
                const SizedBox(height: 6),
                _shimmer(12, 200),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_shimmer(18, 100), _shimmer(12, 60)],
                ),
                const SizedBox(height: 6),
                _shimmer(11, 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer(double height, double width) {
    return Container(
      height: height,
      width: width == double.infinity ? null : width,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: _animation.value * 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
