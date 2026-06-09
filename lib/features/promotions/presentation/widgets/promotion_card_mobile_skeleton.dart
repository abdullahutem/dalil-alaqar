import 'package:flutter/material.dart';

class PromotionCardMobileSkeleton extends StatefulWidget {
  const PromotionCardMobileSkeleton({super.key});

  @override
  State<PromotionCardMobileSkeleton> createState() =>
      _PromotionCardMobileSkeletonState();
}

class _PromotionCardMobileSkeletonState
    extends State<PromotionCardMobileSkeleton>
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
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 160,
              color: Colors.grey.withValues(alpha: _animation.value * 0.3),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge placeholder
                  Container(
                    height: 28,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: _animation.value * 0.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Title placeholder
                  Container(
                    height: 18,
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
                    height: 18,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: _animation.value * 0.3,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description placeholder
                  Container(
                    height: 14,
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
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: _animation.value * 0.2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Discount badge placeholder
                  Container(
                    height: 44,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(
                        alpha: _animation.value * 0.2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey.withValues(
                      alpha: _animation.value * 0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Footer info placeholder
                  Row(
                    children: [
                      Container(
                        height: 14,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(
                            alpha: _animation.value * 0.2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 14,
                        width: 40,
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
          ],
        ),
      ),
    );
  }
}
