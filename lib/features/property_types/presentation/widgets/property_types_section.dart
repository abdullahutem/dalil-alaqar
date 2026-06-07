import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_state.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_type_entity.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_screen.dart';

class PropertyTypesSection extends StatelessWidget {
  final bool isTablet;

  const PropertyTypesSection({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
          child: Text(
            'أنواع العقارات',
            style: TextStyle(
              fontSize: isTablet ? 32 : 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.lightTextSecondary : AppColors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Property Types Horizontal List
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is PropertyTypesError) {
              debugPrint('ddd');
              debugPrint("===========================${state.message}");
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.green[300],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is PropertyTypesSuccess) {
              final propertyTypes = state.response.propertyTypes;

              if (propertyTypes.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'لا توجد أنواع عقارات متاحة',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: isTablet ? 140 : 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
                  itemCount: propertyTypes.length,
                  itemBuilder: (context, index) {
                    final propertyType = propertyTypes[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index == propertyTypes.length - 1 ? 0 : 12,
                      ),
                      child: _PropertyTypeCard(
                        propertyType: propertyType,
                        isDark: isDark,
                        isTablet: isTablet,
                        onTap: () =>
                            _navigateToProperties(context, propertyType),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _navigateToProperties(
    BuildContext context,
    PropertyTypeEntity propertyType,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PropertiesScreen(initialPropertyTypeId: propertyType.id),
      ),
    );
  }
}

class _PropertyTypeCard extends StatelessWidget {
  final PropertyTypeEntity propertyType;
  final bool isDark;
  final bool isTablet;
  final VoidCallback onTap;

  const _PropertyTypeCard({
    required this.propertyType,
    required this.isDark,
    required this.isTablet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: isTablet ? 140 : 110,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(isTablet ? 14 : 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                propertyType.icon,
                style: TextStyle(fontSize: isTablet ? 28 : 24),
              ),
            ),
            const SizedBox(height: 8),
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                propertyType.name,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
