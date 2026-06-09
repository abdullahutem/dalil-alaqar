import 'package:flutter/material.dart';

class OfficesSkeleton extends StatefulWidget {
  const OfficesSkeleton({super.key});

  @override
  State<OfficesSkeleton> createState() => _OfficesSkeletonState();
}

class _OfficesSkeletonState extends State<OfficesSkeleton>
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
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, _) => _buildSkeletonCard(),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonCard() {
    final theme = Theme.of(context);
    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 12, bottom: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section (logo + text)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo placeholder
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(
                      alpha: _animation.value * 0.3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name placeholder
                      Container(
                        height: 14,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(
                            alpha: _animation.value * 0.3,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Location placeholder
                      Container(
                        height: 12,
                        width: 120,
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
            const SizedBox(height: 10),
            // Divider
            Container(
              height: 0.5,
              color: Colors.grey.withValues(alpha: _animation.value * 0.2),
            ),
            const SizedBox(height: 10),
            // Stats section (3 chips)
            Row(
              children: [
                _buildStatChipSkeleton(),
                const SizedBox(width: 6),
                _buildStatChipSkeleton(),
                const SizedBox(width: 6),
                _buildStatChipSkeleton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChipSkeleton() {
    return Expanded(
      child: Container(
        height: 24,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: _animation.value * 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
