import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/employee_stats_cubit.dart';
import '../cubit/employee_stats_state.dart';

class EmployeeStatsSection extends StatelessWidget {
  const EmployeeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeStatsCubit, EmployeeStatsState>(
      builder: (context, state) {
        if (state is EmployeeStatsLoading) {
          return const _StatsLoadingSkeleton();
        }

        if (state is EmployeeStatsError) {
          return _StatsError(message: state.message);
        }

        if (state is EmployeeStatsSuccess) {
          return _StatsContent(
            total: state.stats.total,
            active: state.stats.active,
            inactive: state.stats.inactive,
            canAddMore: state.stats.canAddMore,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _StatsContent extends StatelessWidget {
  final int total;
  final int active;
  final int inactive;
  final bool canAddMore;

  const _StatsContent({
    required this.total,
    required this.active,
    required this.inactive,
    required this.canAddMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'إجمالي الموظفين',
                  value: total.toString(),
                  icon: Icons.people,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'نشط',
                  value: active.toString(),
                  icon: Icons.check_circle,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'غير نشط',
                  value: inactive.toString(),
                  icon: Icons.cancel,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _StatCard(
                  title: 'يمكن الإضافة',
                  value: canAddMore ? 'نعم' : 'لا',
                  icon: canAddMore ? Icons.add_circle : Icons.block,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatsLoadingSkeleton extends StatefulWidget {
  const _StatsLoadingSkeleton();

  @override
  State<_StatsLoadingSkeleton> createState() => _StatsLoadingSkeletonState();
}

class _StatsLoadingSkeletonState extends State<_StatsLoadingSkeleton>
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
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: List.generate(
              2,
              (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: index < 1 ? 12 : 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _shimmerBox(32, 32, circular: 16),
                      const SizedBox(height: 8),
                      _shimmerBox(28, 80, radius: 6),
                      const SizedBox(height: 4),
                      _shimmerBox(12, 100, radius: 6),
                    ],
                  ),
                ),
              ),
            ),
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
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: _animation.value * 0.3),
        shape: circular != null ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular == null ? BorderRadius.circular(radius) : null,
      ),
    );
  }
}

class _StatsError extends StatelessWidget {
  final String message;

  const _StatsError({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
