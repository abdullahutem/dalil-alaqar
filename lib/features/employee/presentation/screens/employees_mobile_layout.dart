import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/employees_cubit.dart';
import '../cubit/employees_state.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_stats_section.dart';
import '../widgets/employees_skeleton.dart';

class EmployeesMobileLayout extends StatefulWidget {
  const EmployeesMobileLayout({super.key});

  @override
  State<EmployeesMobileLayout> createState() => _EmployeesMobileLayoutState();
}

class _EmployeesMobileLayoutState extends State<EmployeesMobileLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<EmployeesCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoading) {
          return ListView.builder(
            itemCount: 6,
            itemBuilder: (_, __) => const EmployeesSkeleton(),
          );
        }

        if (state is EmployeesError) {
          return _buildError(context, state.message);
        }

        if (state is EmployeesSuccess) {
          if (state.employees.isEmpty) {
            return _buildEmpty(context);
          }
          return RefreshIndicator(
            onRefresh: () => context.read<EmployeesCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 8),
              itemCount:
                  state.employees.length + 1 + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (_, index) {
                // First item is the stats section
                if (index == 0) {
                  return const EmployeeStatsSection();
                }

                // Adjust index for employee cards
                final employeeIndex = index - 1;

                if (employeeIndex >= state.employees.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return EmployeeCard(
                  employee: state.employees[employeeIndex],
                  onUpdate: () {
                    context.read<EmployeesCubit>().refresh();
                  },
                  onDelete: () {
                    context.read<EmployeesCubit>().refresh();
                  },
                );
              },
            ),
          );
        }

        if (state is EmployeesLoadMoreError) {
          return RefreshIndicator(
            onRefresh: () => context.read<EmployeesCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: state.employees.length + 2,
              itemBuilder: (_, index) {
                // First item is the stats section
                if (index == 0) {
                  return const EmployeeStatsSection();
                }

                // Adjust index for employee cards
                final employeeIndex = index - 1;

                if (employeeIndex >= state.employees.length) {
                  return _buildLoadMoreError(context, state.message);
                }
                return EmployeeCard(
                  employee: state.employees[employeeIndex],
                  onUpdate: () {
                    context.read<EmployeesCubit>().refresh();
                  },
                  onDelete: () {
                    context.read<EmployeesCubit>().refresh();
                  },
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<EmployeesCubit>().getEmployees(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد موظفون',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          TextButton(
            onPressed: () => context.read<EmployeesCubit>().loadMore(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
