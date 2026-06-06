import 'package:dalil_alaqar/features/office_properties/presentation/widgets/office_property_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/office_properties_cubit.dart';
import '../cubit/office_properties_state.dart';
import '../widgets/office_property_card.dart';

class OfficePropertiesMobileLayout extends StatefulWidget {
  const OfficePropertiesMobileLayout({super.key});

  @override
  State<OfficePropertiesMobileLayout> createState() =>
      _OfficePropertiesMobileLayoutState();
}

class _OfficePropertiesMobileLayoutState
    extends State<OfficePropertiesMobileLayout> {
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
          return ListView.builder(
            itemCount: 4,
            itemBuilder: (_, _) => const OfficePropertiesSkeleton(),
          );
        }

        if (state is OfficePropertiesError) {
          return _buildError(context, state.message);
        }

        if (state is OfficePropertiesSuccess) {
          if (state.properties.isEmpty) return _buildEmpty(context);
          return RefreshIndicator(
            onRefresh: () => context.read<OfficePropertiesCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount:
                  state.properties.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index >= state.properties.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return OfficePropertyCard(property: state.properties[index]);
              },
            ),
          );
        }

        if (state is OfficePropertiesLoadMoreError) {
          return RefreshIndicator(
            onRefresh: () => context.read<OfficePropertiesCubit>().refresh(),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.properties.length + 1,
              itemBuilder: (_, index) {
                if (index >= state.properties.length) {
                  return _buildLoadMoreError(context, state.message);
                }
                return OfficePropertyCard(property: state.properties[index]);
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
            size: 64,
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد عقارات',
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
            onPressed: () => context.read<OfficePropertiesCubit>().loadMore(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
