import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_cubit.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_state.dart';
import 'package:dalil_alaqar/features/governorates/presentation/widgets/governorate_filter_chip.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_cubit.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_state.dart';
import 'package:dalil_alaqar/features/districts/presentation/widgets/district_filter_chip.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/cubit/neighborhoods_cubit.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/cubit/neighborhoods_state.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/widgets/neighborhood_filter_chip.dart';

/// Complete 3-level cascading location selector
/// Governorate → District → Neighborhood
class CompleteLocationSelectorScreen extends StatefulWidget {
  const CompleteLocationSelectorScreen({super.key});

  @override
  State<CompleteLocationSelectorScreen> createState() =>
      _CompleteLocationSelectorScreenState();
}

class _CompleteLocationSelectorScreenState
    extends State<CompleteLocationSelectorScreen> {
  int? selectedGovernorateId;
  int? selectedDistrictId;
  int? selectedNeighborhoodId;

  @override
  void initState() {
    super.initState();
    context.read<GovernoratesCubit>().getGovernorates();
  }

  void _onGovernorateSelected(int governorateId) {
    setState(() {
      if (selectedGovernorateId == governorateId) {
        selectedGovernorateId = null;
        selectedDistrictId = null;
        selectedNeighborhoodId = null;
        context.read<DistrictsCubit>().clearDistricts();
        context.read<NeighborhoodsCubit>().clearNeighborhoods();
      } else {
        selectedGovernorateId = governorateId;
        selectedDistrictId = null;
        selectedNeighborhoodId = null;
        context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
        context.read<NeighborhoodsCubit>().clearNeighborhoods();
      }
    });
  }

  void _onDistrictSelected(int districtId) {
    setState(() {
      if (selectedDistrictId == districtId) {
        selectedDistrictId = null;
        selectedNeighborhoodId = null;
        context.read<NeighborhoodsCubit>().clearNeighborhoods();
      } else {
        selectedDistrictId = districtId;
        selectedNeighborhoodId = null;
        context.read<NeighborhoodsCubit>().getNeighborhoodsByDistrict(
          districtId,
        );
      }
    });
  }

  void _onNeighborhoodSelected(int neighborhoodId) {
    setState(() {
      if (selectedNeighborhoodId == neighborhoodId) {
        selectedNeighborhoodId = null;
      } else {
        selectedNeighborhoodId = neighborhoodId;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedGovernorateId = null;
      selectedDistrictId = null;
      selectedNeighborhoodId = null;
    });
    context.read<DistrictsCubit>().clearDistricts();
    context.read<NeighborhoodsCubit>().clearNeighborhoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار الموقع الكامل'),
        backgroundColor: AppColors.primary,
        actions: [
          if (selectedGovernorateId != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearSelection,
              tooltip: 'مسح الاختيار',
            ),
        ],
      ),
      body: Column(
        children: [
          // Selected location breadcrumb
          if (selectedGovernorateId != null) _buildLocationBreadcrumb(),
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGovernoratesSection(),
                  if (selectedGovernorateId != null) ...[
                    const Divider(height: 32),
                    _buildDistrictsSection(),
                  ],
                  if (selectedDistrictId != null) ...[
                    const Divider(height: 32),
                    _buildNeighborhoodsSection(),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Apply button
          if (selectedGovernorateId != null) _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildLocationBreadcrumb() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppColors.primary.withOpacity(0.1),
      child: BlocBuilder<GovernoratesCubit, GovernoratesState>(
        builder: (context, govState) {
          if (govState is! GovernoratesSuccess) return const SizedBox.shrink();

          final gov = govState.response.governorates.firstWhere(
            (g) => g.id == selectedGovernorateId,
          );

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildBreadcrumbItem(Icons.location_city, gov.nameAr),
              if (selectedDistrictId != null) ...[
                const Icon(Icons.arrow_forward, size: 16),
                BlocBuilder<DistrictsCubit, DistrictsState>(
                  builder: (context, distState) {
                    if (distState is! DistrictsSuccess) {
                      return const SizedBox.shrink();
                    }
                    final district = distState.response.districts.firstWhere(
                      (d) => d.id == selectedDistrictId,
                    );
                    return _buildBreadcrumbItem(Icons.place, district.nameAr);
                  },
                ),
              ],
              if (selectedNeighborhoodId != null) ...[
                const Icon(Icons.arrow_forward, size: 16),
                BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
                  builder: (context, neighState) {
                    if (neighState is! NeighborhoodsSuccess) {
                      return const SizedBox.shrink();
                    }
                    final neighborhood = neighState.response.neighborhoods
                        .firstWhere((n) => n.id == selectedNeighborhoodId);
                    return _buildBreadcrumbItem(
                      Icons.home,
                      neighborhood.nameAr,
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBreadcrumbItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildGovernoratesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '1. اختر المحافظة:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<GovernoratesCubit, GovernoratesState>(
            builder: (context, state) {
              if (state is GovernoratesLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is GovernoratesError) {
                return _buildErrorWidget(
                  state.message,
                  () => context.read<GovernoratesCubit>().getGovernorates(),
                );
              }
              if (state is GovernoratesSuccess) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.response.governorates.map((gov) {
                    return GovernorateFilterChip(
                      governorate: gov,
                      isSelected: selectedGovernorateId == gov.id,
                      showDistrictsCount: true,
                      onTap: () => _onGovernorateSelected(gov.id),
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDistrictsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2. اختر المديرية:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<DistrictsCubit, DistrictsState>(
            builder: (context, state) {
              if (state is DistrictsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is DistrictsError) {
                return _buildErrorWidget(state.message, () {
                  if (selectedGovernorateId != null) {
                    context.read<DistrictsCubit>().getDistrictsByGovernorate(
                      selectedGovernorateId!,
                    );
                  }
                });
              }
              if (state is DistrictsSuccess) {
                if (state.response.districts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('لا توجد مديريات متاحة'),
                    ),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.response.districts.map((district) {
                    return DistrictFilterChip(
                      district: district,
                      isSelected: selectedDistrictId == district.id,
                      onTap: () => _onDistrictSelected(district.id),
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNeighborhoodsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '3. اختر الحي:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<NeighborhoodsCubit, NeighborhoodsState>(
            builder: (context, state) {
              if (state is NeighborhoodsLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (state is NeighborhoodsError) {
                return _buildErrorWidget(state.message, () {
                  if (selectedDistrictId != null) {
                    context
                        .read<NeighborhoodsCubit>()
                        .getNeighborhoodsByDistrict(selectedDistrictId!);
                  }
                });
              }
              if (state is NeighborhoodsSuccess) {
                if (state.response.neighborhoods.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('لا توجد أحياء متاحة'),
                    ),
                  );
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.response.neighborhoods.map((neighborhood) {
                    return NeighborhoodFilterChip(
                      neighborhood: neighborhood,
                      isSelected: selectedNeighborhoodId == neighborhood.id,
                      onTap: () => _onNeighborhoodSelected(neighborhood.id),
                    );
                  }).toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, {
            'governorateId': selectedGovernorateId,
            'districtId': selectedDistrictId,
            'neighborhoodId': selectedNeighborhoodId,
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'تطبيق الفلتر',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
