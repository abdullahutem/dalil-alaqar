import 'package:dalil_alaqar/core/routes/app_routes.dart';
import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_cubit.dart';
import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_state.dart';
import 'package:dalil_alaqar/features/offices/presentation/widgets/office_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfficesMobileLayout extends StatefulWidget {
  const OfficesMobileLayout({super.key});

  @override
  State<OfficesMobileLayout> createState() => _OfficesMobileLayoutState();
}

class _OfficesMobileLayoutState extends State<OfficesMobileLayout> {
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
          return _buildList(context, state);
        }

        if (state is OfficesLoadMoreError) {
          return _buildListWithLoadMoreError(context, state);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(BuildContext context, OfficesSuccess state) {
    if (state.offices.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => context.read<OfficesCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.offices.length + (state.hasReachedMax ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == state.offices.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return OfficeCard(
            office: state.offices[index],
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.officeDetails,
              arguments: state.offices[index].id,
            ),
          );
        },
      ),
    );
  }

  Widget _buildListWithLoadMoreError(
    BuildContext context,
    OfficesLoadMoreError state,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<OfficesCubit>().refresh(),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: state.offices.length + 1,
        itemBuilder: (context, index) {
          if (index == state.offices.length) {
            return _buildLoadMoreErrorWidget(context, state.message);
          }
          return OfficeCard(
            office: state.offices[index],
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.officeDetails,
              arguments: state.offices[index].id,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreErrorWidget(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.read<OfficesCubit>().loadMore(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('حدث خطأ', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
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
            size: 80,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text('لا توجد مكاتب', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي مكاتب عقارية',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
