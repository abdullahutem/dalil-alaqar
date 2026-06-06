import 'package:flutter/material.dart';

class ProfileHeaderSkeleton extends StatefulWidget {
  const ProfileHeaderSkeleton({super.key});

  @override
  State<ProfileHeaderSkeleton> createState() => _ProfileHeaderSkeletonState();
}

class _ProfileHeaderSkeletonState extends State<ProfileHeaderSkeleton>
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
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 50,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar skeleton
              _shimmerCircle(80),
              const SizedBox(height: 12),
              // Office name skeleton
              _shimmerBox(20, 200),
              const SizedBox(height: 8),
              // User name skeleton
              _shimmerBox(14, 160),
              const SizedBox(height: 6),
              // Email skeleton
              _shimmerBox(12, 140),
              const SizedBox(height: 8),
              // Role badge skeleton
              _shimmerBox(24, 60, radius: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(double height, double width, {double radius = 6}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _animation.value * 0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  Widget _shimmerCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _animation.value * 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}
