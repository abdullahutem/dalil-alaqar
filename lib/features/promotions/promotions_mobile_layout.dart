import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/promotions_cubit.dart';
import '../cubit/promotions_state.dart';
import '../widgets/promotion_card.dart';

class PromotionsMobileLayout extends StatelessWidget {
  const PromotionsMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PromotionsCubit, PromotionsState>(
      builder: (context, state) {
        if (state is PromotionsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PromotionsError) {
          return _buildErrorState(context, state.message);
        }
        if (state is PromotionsSuccess) {
          if (state.promotions.isEmpty) return _buildEmptyState(context);
          return RefreshIndicator(
            onRefresh: () => context.read<PromotionsCubit>().refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.promotions.length,
              itemBuilder: (context, index) =>
                  PromotionCard(promotion: state.promotions[index]),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text('حدث خطأ', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(message,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<PromotionsCubit>().getPromotions(),
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
          Icon(Icons.local_offer_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('لا توجد عروض', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'لا توجد عروض ترويجية متاحة حالياً',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.textTheme.bodySmall?.color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
