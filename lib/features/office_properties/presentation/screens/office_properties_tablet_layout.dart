import 'package:dalil_alaqar/features/office_properties/presentation/widgets/office_property_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_properties_cubit.dart';
import '../cubit/office_properties_state.dart';
import '../widgets/office_property_card_tablet.dart';
import '../widgets/property_stats_widget.dart';
import '../../domain/entities/property_stats_entity.dart';

class OfficePropertiesTabletLayout extends StatefulWidget {
  const OfficePropertiesTabletLayout({super.key});

  @override
  State<OfficePropertiesTabletLayout> createState() =>
      _OfficePropertiesTabletLayoutState();
}

class _OfficePropertiesTabletLayoutState
    extends State<OfficePropertiesTabletLayout> {
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
      context.read<OfficePropertiesCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficePropertiesCubit, OfficePropertiesState>(
      builder: (context, state) {
        if (state is OfficePropertiesLoading) {
          return _buildSkeletonGrid();
        }

        if (state is OfficePropertiesError) {
          return _buildError(context, state.message);
        }

        if (state is OfficePropertiesSuccess) {
          if (state.properties.isEmpty) return _buildEmpty(context);
          return RefreshIndicator(
            onRefresh: () => context.read<OfficePropertiesCubit>().refresh(),
            child: _buildGrid(context, state),
          );
        }

        if (state is OfficePropertiesLoadMoreError) {
          return RefreshIndicator(
            onRefresh: () => context.read<OfficePropertiesCubit>().refresh(),
            child: _buildGrid(
              context,
              OfficePropertiesSuccess(
                properties: state.properties,
                currentPage: state.currentPage,
                lastPage: state.lastPage,
                total: state.total,
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
            childAspectRatio: 0.85,
          ),
          itemCount: 4,
          itemBuilder: (_, __) =>
              const OfficePropertiesSkeleton(isTablet: true),
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context,
    OfficePropertiesSuccess state, {
    String? loadMoreError,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Stats widget at the top
            if (state.stats != null || state.isLoadingStats)
              SliverToBoxAdapter(
                child: PropertyStatsWidget(
                  stats:
                      state.stats ??
                      const PropertyStatsEntity(
                        total: 0,
                        available: 0,
                        reserved: 0,
                        sold: 0,
                        rented: 0,
                      ),
                  isLoading: state.isLoadingStats,
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (_, index) => OfficePropertyCardTablet(
                    property: state.properties[index],
                  ),
                  childCount: state.properties.length,
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
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        loadMoreError,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextButton(
                        onPressed: () =>
                            context.read<OfficePropertiesCubit>().loadMore(),
                        child: const Text('إعادة المحاولة'),
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
              onPressed: () =>
                  context.read<OfficePropertiesCubit>().getOfficeProperties(),
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
            Icons.home_work_outlined,
            size: 80,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عقارات',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
