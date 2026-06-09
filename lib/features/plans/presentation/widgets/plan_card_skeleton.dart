import 'package:flutter/material.dart';

class PlanCardSkeleton extends StatefulWidget {
  const PlanCardSkeleton({super.key});

  @override
  State<PlanCardSkeleton> createState() => _PlanCardSkeletonState();
}

class _PlanCardSkeletonState extends State<PlanCardSkeleton>
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
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon placeholder
                _shimmerBox(48, 48, radius: 10),
                const SizedBox(width: 12),

                // Content placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _shimmerBox(16, 120),
                      const SizedBox(height: 6),
                      _shimmerBox(12, double.infinity),
                      const SizedBox(height: 8),
                      _shimmerBox(18, 100),
                    ],
                  ),
                ),

                const SizedBox(width: 12),
                // Arrow placeholder
                _shimmerBox(16, 16, radius: 4),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double height, double width, {double radius = 6}) {
    return Container(
      height: height,
      width: width == double.infinity ? null : width,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: _animation.value * 0.3),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
