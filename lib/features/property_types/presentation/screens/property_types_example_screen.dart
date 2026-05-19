import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_state.dart';
import 'package:dalil_alaqar/features/property_types/presentation/widgets/property_type_filter_chip.dart';

/// Example screen demonstrating how to use the Property Types feature
class PropertyTypesExampleScreen extends StatefulWidget {
  const PropertyTypesExampleScreen({super.key});

  @override
  State<PropertyTypesExampleScreen> createState() =>
      _PropertyTypesExampleScreenState();
}

class _PropertyTypesExampleScreenState
    extends State<PropertyTypesExampleScreen> {
  int? selectedPropertyTypeId;

  @override
  void initState() {
    super.initState();
    // Load property types when screen initializes
    context.read<PropertyTypesCubit>().getPropertyTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أنواع العقارات'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
        builder: (context, state) {
          if (state is PropertyTypesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PropertyTypesError) {
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
                      context.read<PropertyTypesCubit>().getPropertyTypes();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is PropertyTypesSuccess) {
            final propertyTypes = state.response.propertyTypes;

            if (propertyTypes.isEmpty) {
              return const Center(child: Text('لا توجد أنواع عقارات متاحة'));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter chips section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اختر نوع العقار:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: propertyTypes.map((propertyType) {
                            return PropertyTypeFilterChip(
                              propertyType: propertyType,
                              isSelected:
                                  selectedPropertyTypeId == propertyType.id,
                              onTap: () {
                                setState(() {
                                  if (selectedPropertyTypeId ==
                                      propertyType.id) {
                                    selectedPropertyTypeId = null;
                                  } else {
                                    selectedPropertyTypeId = propertyType.id;
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  // List view section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'جميع أنواع العقارات:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: propertyTypes.length,
                          itemBuilder: (context, index) {
                            final propertyType = propertyTypes[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Text(
                                  propertyType.icon,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                title: Text(
                                  propertyType.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: propertyType.description != null
                                    ? Text(propertyType.description!)
                                    : null,
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: propertyType.isActive
                                        ? Colors.green[100]
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    propertyType.isActive ? 'نشط' : 'غير نشط',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: propertyType.isActive
                                          ? Colors.green[800]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
