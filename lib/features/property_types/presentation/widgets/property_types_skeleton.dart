import 'package:flutter/material.dart';

class PropertyTypesSkeleton extends StatefulWidget {
  final bool isTablet;

  const PropertyTypesSkeleton({super.key, this.isTablet = false});

  @override
  State<PropertyTypesSkeleton> createState() => _PropertyTypesSkeletonState();
}

class _PropertyTypesSkeletonState extends State<PropertyTypesSkeleton>
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
    return SizedBox(
      height: widget.isTablet ? 140 : 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: widget.isTablet ? 32 : 16),
        itemCount: 5, // Show 5 skeleton cards
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 4 ? 0 : 12),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, _) => _buildSkeletonCard(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final theme = Theme.of(context);
    return Container(
      width: widget.isTablet ? 140 : 110,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon placeholder (circle)
          Container(
            width: widget.isTablet ? 56 : 48,
            height: widget.isTablet ? 56 : 48,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: _animation.value * 0.3),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          // Name placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  height: widget.isTablet ? 13 : 12,
                  width: widget.isTablet ? 100 : 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(
                      alpha: _animation.value * 0.3,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: widget.isTablet ? 13 : 12,
                  width: widget.isTablet ? 70 : 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(
                      alpha: _animation.value * 0.3,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
