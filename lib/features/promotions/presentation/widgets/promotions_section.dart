import 'package:dalil_alaqar/features/promotions/domain/entities/promotion_entity.dart';
import 'package:dalil_alaqar/features/promotions/presentation/screens/promotions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/promotions/presentation/cubit/promotions_cubit.dart';
import 'package:dalil_alaqar/features/promotions/presentation/cubit/promotions_state.dart';

import 'promotion_card_compact.dart';

class PromotionsSection extends StatefulWidget {
  const PromotionsSection({super.key});

  @override
  State<PromotionsSection> createState() => _PromotionsSectionState();
}

class _PromotionsSectionState extends State<PromotionsSection> {
  late final PromotionsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PromotionsCubit.create()..getPromotions();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<PromotionsCubit, PromotionsState>(
        builder: (context, state) {
          if (state is PromotionsLoading) {
            return _buildLoadingSection(context);
          }
          if (state is PromotionsSuccess && state.promotions.isNotEmpty) {
            return _buildSection(context, state.promotions);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, List<PromotionEntity> promotions) {
    final theme = Theme.of(context);
    final displayed = promotions.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_offer,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'العروض الترويجية',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromotionsScreen()),
                ),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 168,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: displayed.length,
            itemBuilder: (context, index) {
              return PromotionCardCompact(
                promotion: displayed[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PromotionsScreen()),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLoadingSection(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'العروض الترويجية',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 168,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              width: 240,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
