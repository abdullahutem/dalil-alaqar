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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
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

class _StatsLoadingSkeleton extends StatelessWidget {
  const _StatsLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(
          2,
          (index) => Expanded(
            child: Container(
              margin: EdgeInsets.only(left: index < 1 ? 12 : 0),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
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
          borderRadius: BorderRadius.circular(12),
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
