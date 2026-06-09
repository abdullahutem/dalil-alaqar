import 'package:flutter/material.dart';

class PromotionCardTabletSkeleton extends StatefulWidget {
  const PromotionCardTabletSkeleton({super.key});

  @override
  State<PromotionCardTabletSkeleton> createState() =>
      _PromotionCardTabletSkeletonState();
}

class _PromotionCardTabletSkeletonState
    extends State<PromotionCardTabletSkeleton>
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
      builder: (context, _) => _buildCard(),
    );
  }

  Widget _buildCard() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder (Left)
            Container(
              width: 280,
              height: 320,
              color: Colors.grey.withValues(alpha: _animation.value * 0.3),
            ),

            // Content Section (Right)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type badge placeholder
                    Container(
                      height: 32,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title placeholder
                    Container(
                      height: 24,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 24,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.3,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description placeholder
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 16,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 16,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Discount badge placeholder
                    Container(
                      height: 52,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(
                          alpha: _animation.value * 0.2,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    Container(
                      height: 1,
                      color: Colors.grey.withValues(
                        alpha: _animation.value * 0.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer info placeholders
                    Row(
                      children: [
                        Container(
                          height: 16,
                          width: 140,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(
                              alpha: _animation.value * 0.2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Container(
                          height: 16,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(
                              alpha: _animation.value * 0.2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
