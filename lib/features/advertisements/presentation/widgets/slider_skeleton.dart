import 'package:flutter/material.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';

class SliderSkeleton extends StatefulWidget {
  final bool isTablet;

  const SliderSkeleton({super.key, this.isTablet = false});

  @override
  State<SliderSkeleton> createState() => _SliderSkeletonState();
}

class _SliderSkeletonState extends State<SliderSkeleton>
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
    final height = widget.isTablet ? 400.0 : 320.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          margin: widget.isTablet
              ? const EdgeInsets.fromLTRB(24, 0, 24, 0)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurface
                : AppColors.grey.withValues(alpha: 0.2),
          ),
          child: Stack(
            children: [
              // Background shimmer
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.grey.withValues(alpha: _animation.value * 0.3),
                      AppColors.grey.withValues(alpha: _animation.value * 0.1),
                      AppColors.grey.withValues(alpha: _animation.value * 0.3),
                    ],
                  ),
                ),
              ),

              // Content skeleton
              Positioned(
                bottom: widget.isTablet ? 48 : 32,
                left: widget.isTablet ? 48 : 32,
                right: widget.isTablet ? 48 : 32,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    Container(
                      height: widget.isTablet ? 36 : 28,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: widget.isTablet ? 36 : 28,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Subtitle skeleton
                    Container(
                      height: widget.isTablet ? 16 : 14,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _animation.value * 0.25,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: widget.isTablet ? 16 : 14,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: _animation.value * 0.25,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),

              // Indicators skeleton
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == 0 ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(
                          alpha: index == 0 ? 0.5 : 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
