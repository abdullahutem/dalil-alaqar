import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_cubit.dart';
import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_state.dart';
import 'package:dalil_alaqar/features/offices/presentation/widgets/office_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfficesTabletLayout extends StatefulWidget {
  const OfficesTabletLayout({super.key});

  @override
  State<OfficesTabletLayout> createState() => _OfficesTabletLayoutState();
}

class _OfficesTabletLayoutState extends State<OfficesTabletLayout> {
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
        _scrollController.position.maxScrollExtent - 300) {
      context.read<OfficesCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfficesCubit, OfficesState>(
      builder: (context, state) {
        if (state is OfficesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OfficesError) {
          return _buildErrorState(context, state.message);
        }

        if (state is OfficesSuccess) {
          return _buildGrid(context, state);
        }

        if (state is OfficesLoadMoreError) {
          return _buildGridWithError(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGrid(BuildContext context, OfficesSuccess state) {
    if (state.offices.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OfficesCubit>().refresh(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
            ),
            itemCount: state.offices.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index == state.offices.length) {
                return const Center(child: CircularProgressIndicator());
              }
              return OfficeCard(office: state.offices[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGridWithError(BuildContext context, OfficesLoadMoreError state) {
    return RefreshIndicator(
      onRefresh: () => context.read<OfficesCubit>().refresh(),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 0,
              childAspectRatio: 1.3,
            ),
            itemCount: state.offices.length + 1,
            itemBuilder: (context, index) {
              if (index == state.offices.length) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<OfficesCubit>().loadMore(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              }
              return OfficeCard(office: state.offices[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text('حدث خطأ', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<OfficesCubit>().getOffices(),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 100,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text('لا توجد مكاتب', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي مكاتب عقارية',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
