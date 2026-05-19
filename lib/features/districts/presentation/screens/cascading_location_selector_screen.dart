import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_cubit.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_state.dart';
import 'package:dalil_alaqar/features/governorates/presentation/widgets/governorate_filter_chip.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_cubit.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_state.dart';
import 'package:dalil_alaqar/features/districts/presentation/widgets/district_filter_chip.dart';

/// Example screen demonstrating cascading location selection
/// (Governorate → Districts)
class CascadingLocationSelectorScreen extends StatefulWidget {
  const CascadingLocationSelectorScreen({super.key});

  @override
  State<CascadingLocationSelectorScreen> createState() =>
      _CascadingLocationSelectorScreenState();
}

class _CascadingLocationSelectorScreenState
    extends State<CascadingLocationSelectorScreen> {
  int? selectedGovernorateId;
  int? selectedDistrictId;

  @override
  void initState() {
    super.initState();
    // Load governorates when screen initializes
    context.read<GovernoratesCubit>().getGovernorates();
  }

  void _onGovernorateSelected(int governorateId) {
    setState(() {
      if (selectedGovernorateId == governorateId) {
        // Deselect
        selectedGovernorateId = null;
        selectedDistrictId = null;
        context.read<DistrictsCubit>().clearDistricts();
      } else {
        // Select new governorate
        selectedGovernorateId = governorateId;
        selectedDistrictId = null;
        // Load districts for selected governorate
        context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
      }
    });
  }

  void _onDistrictSelected(int districtId) {
    setState(() {
      if (selectedDistrictId == districtId) {
        selectedDistrictId = null;
      } else {
        selectedDistrictId = districtId;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      selectedGovernorateId = null;
      selectedDistrictId = null;
    });
    context.read<DistrictsCubit>().clearDistricts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار الموقع'),
        backgroundColor: AppColors.primary,
        actions: [
          if (selectedGovernorateId != null || selectedDistrictId != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearSelection,
              tooltip: 'مسح الاختيار',
            ),
        ],
      ),
      body: Column(
        children: [
          // Selected location summary
          if (selectedGovernorateId != null || selectedDistrictId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الموقع المحدد:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<GovernoratesCubit, GovernoratesState>(
                    builder: (context, govState) {
                      if (govState is GovernoratesSuccess &&
                          selectedGovernorateId != null) {
                        final gov = govState.response.governorates.firstWhere(
                          (g) => g.id == selectedGovernorateId,
                        );
                        return Row(
                          children: [
                            Icon(
                              Icons.location_city,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              gov.nameAr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            if (selectedDistrictId != null) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 16),
                              const SizedBox(width: 8),
                              BlocBuilder<DistrictsCubit, DistrictsState>(
                                builder: (context, distState) {
                                  if (distState is DistrictsSuccess) {
                                    final district = distState
                                        .response
                                        .districts
                                        .firstWhere(
                                          (d) => d.id == selectedDistrictId,
                                        );
                                    return Text(
                                      district.nameAr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          // Governorates section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '1. اختر المحافظة:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: AppColors.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.message,
                                  style: TextStyle(color: AppColors.error),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<GovernoratesCubit>()
                                        .getGovernorates();
                                  },
                                  child: const Text('إعادة المحاولة'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is GovernoratesSuccess) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
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
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 24),
                  // Districts section
                  if (selectedGovernorateId != null) ...[
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        '2. اختر المديرية:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.message,
                                    style: TextStyle(color: AppColors.error),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (selectedGovernorateId != null) {
                                        context
                                            .read<DistrictsCubit>()
                                            .getDistrictsByGovernorate(
                                              selectedGovernorateId!,
                                            );
                                      }
                                    },
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            ),
                          );
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

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: state.response.districts.map((
                                district,
                              ) {
                                return DistrictFilterChip(
                                  district: district,
                                  isSelected: selectedDistrictId == district.id,
                                  onTap: () => _onDistrictSelected(district.id),
                                );
                              }).toList(),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
          // Apply button
          if (selectedGovernorateId != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Apply filter or navigate back with selection
                  Navigator.pop(context, {
                    'governorateId': selectedGovernorateId,
                    'districtId': selectedDistrictId,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'تطبيق الفلتر',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
