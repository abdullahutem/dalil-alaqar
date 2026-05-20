import 'package:flutter/material.dart';

class EmployeesSkeleton extends StatefulWidget {
  final bool isTablet;

  const EmployeesSkeleton({super.key, this.isTablet = false});

  @override
  State<EmployeesSkeleton> createState() => _EmployeesSkeletonState();
}

class _EmployeesSkeletonState extends State<EmployeesSkeleton>
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
    return widget.isTablet ? _buildTabletSkeleton() : _buildMobileSkeleton();
  }

  Widget _buildMobileSkeleton() {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _shimmerBox(52, 52, circular: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(12, double.infinity),
                    const SizedBox(height: 8),
                    _shimmerBox(10, double.infinity),
                    const SizedBox(height: 6),
                    _shimmerBox(10, double.infinity),
                    const SizedBox(height: 6),
                    _shimmerBox(10, double.infinity),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _shimmerBox(30, 50, radius: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabletSkeleton() {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmerBox(64, 64, circular: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(16, double.infinity),
                        const SizedBox(height: 8),
                        _shimmerBox(12, double.infinity),
                      ],
                    ),
                  ),
                  _shimmerBox(32, 64, radius: 8),
                ],
              ),
              const SizedBox(height: 16),
              _shimmerBox(1, double.infinity),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _shimmerBox(12, double.infinity)),
                  const SizedBox(width: 16),
                  Expanded(child: _shimmerBox(12, double.infinity)),
                ],
              ),
              const SizedBox(height: 8),
              _shimmerBox(12, double.infinity),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerBox(
    double height,
    double width, {
    double? circular,
    double radius = 6,
  }) {
    return Container(
      height: height,
      width: width == double.infinity ? null : width,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: _animation.value * 0.3),
        shape: circular != null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular == null ? BorderRadius.circular(radius) : null,
      ),
    );
  }
}
