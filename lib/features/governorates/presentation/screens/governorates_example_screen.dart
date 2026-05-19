import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_cubit.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_state.dart';
import 'package:dalil_alaqar/features/governorates/presentation/widgets/governorate_filter_chip.dart';

/// Example screen demonstrating how to use the Governorates feature
class GovernoratesExampleScreen extends StatefulWidget {
  const GovernoratesExampleScreen({super.key});

  @override
  State<GovernoratesExampleScreen> createState() =>
      _GovernoratesExampleScreenState();
}

class _GovernoratesExampleScreenState extends State<GovernoratesExampleScreen> {
  int? selectedGovernorateId;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load governorates when screen initializes
    context.read<GovernoratesCubit>().getGovernorates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحافظات'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<GovernoratesCubit, GovernoratesState>(
        builder: (context, state) {
          if (state is GovernoratesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GovernoratesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GovernoratesCubit>().getGovernorates();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is GovernoratesSuccess) {
            final governorates = state.response.governorates.where((gov) {
              if (searchQuery.isEmpty) return true;
              return gov.nameAr.contains(searchQuery) ||
                  gov.nameEn.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            if (governorates.isEmpty) {
              return const Center(child: Text('لا توجد محافظات متاحة'));
            }

            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن محافظة...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                // Filter chips section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'اختر المحافظة:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (selectedGovernorateId != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedGovernorateId = null;
                                });
                              },
                              child: const Text('مسح الاختيار'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: governorates.map((governorate) {
                          return GovernorateFilterChip(
                            governorate: governorate,
                            isSelected: selectedGovernorateId == governorate.id,
                            showDistrictsCount: true,
                            onTap: () {
                              setState(() {
                                if (selectedGovernorateId == governorate.id) {
                                  selectedGovernorateId = null;
                                } else {
                                  selectedGovernorateId = governorate.id;
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                // List view section
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: governorates.length,
                    itemBuilder: (context, index) {
                      final governorate = governorates[index];
                      final isSelected =
                          selectedGovernorateId == governorate.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: isSelected ? 4 : 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.location_city,
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[600],
                              size: 24,
                            ),
                          ),
                          title: Text(
                            governorate.nameAr,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                governorate.nameEn,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${governorate.districtsCount} مديرية',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: governorate.isActive
                                  ? Colors.green[100]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              governorate.isActive ? 'نشط' : 'غير نشط',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: governorate.isActive
                                    ? Colors.green[800]
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedGovernorateId = governorate.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
