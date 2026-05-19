import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_cubit.dart';
import 'package:dalil_alaqar/features/offices/presentation/cubit/offices_state.dart';
import 'package:dalil_alaqar/features/offices/presentation/screens/offices_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'office_card_compact.dart';

class OfficesSection extends StatefulWidget {
  const OfficesSection({super.key});

  @override
  State<OfficesSection> createState() => _OfficesSectionState();
}

class _OfficesSectionState extends State<OfficesSection> {
  late final OfficesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OfficesCubit.create()..getOffices();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<OfficesCubit, OfficesState>(
        builder: (context, state) {
          if (state is OfficesLoading) {
            return _buildLoadingSection(context);
          }
          if (state is OfficesSuccess && state.offices.isNotEmpty) {
            return _buildSection(context, state.offices, theme);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    List<OfficeEntity> offices,
    ThemeData theme,
  ) {
    final displayed = offices.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المكاتب العقارية',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OfficesScreen()),
                ),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: displayed.length,
            itemBuilder: (context, index) {
              return OfficeCardCompact(
                office: displayed[index],
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const OfficesScreen()),
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
            'المكاتب العقارية',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16),
            itemCount: 4,
            itemBuilder: (context, index) => _buildSkeletonCard(context),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSkeletonCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 12, bottom: 4),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
