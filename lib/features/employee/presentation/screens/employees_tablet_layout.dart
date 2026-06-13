import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/employees_cubit.dart';
import '../cubit/employees_state.dart';
import '../widgets/employee_card_tablet.dart';
import '../widgets/employee_stats_section.dart';
import '../widgets/employees_skeleton.dart';

class EmployeesTabletLayout extends StatefulWidget {
  const EmployeesTabletLayout({super.key});

  @override
  State<EmployeesTabletLayout> createState() => _EmployeesTabletLayoutState();
}

class _EmployeesTabletLayoutState extends State<EmployeesTabletLayout> {
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
          return _buildSkeletonGrid();
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
            child: _buildGrid(context, state),
          );
        }

        if (state is EmployeesLoadMoreError) {
          return RefreshIndicator(
            onRefresh: () => context.read<EmployeesCubit>().refresh(),
            child: _buildGrid(
              context,
              EmployeesSuccess(
                employees: state.employees,
                currentPage: state.currentPage,
                lastPage: state.lastPage,
              ),
              loadMoreError: state.message,
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSkeletonGrid() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 2.0,
          ),
          itemCount: 12,
          itemBuilder: (_, __) => const EmployeesSkeleton(isTablet: true),
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    EmployeesSuccess state, {
    String? loadMoreError,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const SliverToBoxAdapter(child: EmployeeStatsSection()),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.7,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) => EmployeeCardTablet(
                    employee: state.employees[index],
                    onUpdate: () {
                      context.read<EmployeesCubit>().refresh();
                    },
                    onDelete: () {
                      context.read<EmployeesCubit>().refresh();
                    },
                  ),
                  childCount: state.employees.length,
                ),
              ),
            ),
            if (state.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            if (loadMoreError != null)
              SliverToBoxAdapter(
                child: _buildLoadMoreError(context, loadMoreError),
              ),
          ],
        ),
      ),
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
            Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
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
            size: 80,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد موظفون',
            style: theme.textTheme.titleMedium?.copyWith(
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
          Text(message, style: Theme.of(context).textTheme.bodySmall),
          TextButton(
            onPressed: () => context.read<EmployeesCubit>().loadMore(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
