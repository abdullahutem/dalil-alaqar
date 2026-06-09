import 'package:dalil_alaqar/features/promotions/presentation/widgets/promotion_card_tablet.dart';
import 'package:dalil_alaqar/features/promotions/presentation/widgets/promotion_card_tablet_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/promotions/presentation/cubit/promotions_cubit.dart';
import 'package:dalil_alaqar/features/promotions/presentation/cubit/promotions_state.dart';

class PromotionsTabletLayout extends StatelessWidget {
  const PromotionsTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionsCubit, PromotionsState>(
      builder: (context, state) {
        if (state is PromotionsLoading) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1400),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: 3,
                itemBuilder: (context, index) =>
                    const PromotionCardTabletSkeleton(),
              ),
            ),
          );
        }
        if (state is PromotionsError) {
          return _buildErrorState(context, state.message);
        }
        if (state is PromotionsSuccess) {
          if (state.promotions.isEmpty) return _buildEmptyState(context);
          return RefreshIndicator(
            onRefresh: () => context.read<PromotionsCubit>().refresh(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: state.promotions.length,
                  itemBuilder: (context, index) =>
                      PromotionCardTablet(promotion: state.promotions[index]),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
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
            onPressed: () => context.read<PromotionsCubit>().getPromotions(),
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
            Icons.local_offer_outlined,
            size: 100,
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text('لا توجد عروض', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'لا توجد عروض ترويجية متاحة حالياً',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
