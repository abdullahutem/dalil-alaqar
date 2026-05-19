import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_state.dart';
import 'package:dalil_alaqar/features/properties/presentation/widgets/property_card_compact.dart';
import 'package:dalil_alaqar/features/properties/presentation/screens/properties_screen.dart';

class PropertiesSection extends StatelessWidget {
  final bool isTablet;

  const PropertiesSection({super.key, this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 48 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أحدث العقارات',
                      style: TextStyle(
                        fontSize: isTablet ? 32 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'تصفح أحدث العقارات المتاحة',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) =>
                              PropertiesCubit.create()..getProperties(),
                          child: const PropertiesScreen(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('عرض الكل'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Properties Horizontal List
          BlocBuilder<PropertiesCubit, PropertiesState>(
            builder: (context, state) {
              if (state is PropertiesLoading) {
                return SizedBox(
                  height: isTablet ? 320 : 280,
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state is PropertiesError) {
                return Container(
                  height: isTablet ? 320 : 280,
                  margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: isTablet ? 64 : 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: isTablet ? 16 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PropertiesCubit>().getProperties();
                          },
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PropertiesSuccess) {
                final properties = state.propertiesResponse.properties;

                if (properties.isEmpty) {
                  return Container(
                    height: isTablet ? 320 : 280,
                    margin: EdgeInsets.symmetric(
                      horizontal: isTablet ? 24 : 16,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home_outlined,
                            size: isTablet ? 64 : 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لا توجد عقارات متاحة حالياً',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show first 10 properties
                final displayProperties = properties.take(10).toList();

                return Column(
                  children: [
                    // Horizontal scrolling list
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                      ),
                      child: Row(
                        children: displayProperties.map((property) {
                          return PropertyCardCompact(
                            property: property,
                            onTap: () {
                              // TODO: Navigate to property details
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تم النقر على: ${property.title}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // View All Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 24 : 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      PropertiesCubit.create()..getProperties(),
                                  child: const PropertiesScreen(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: Text(
                            'عرض جميع العقارات (${state.propertiesResponse.meta.total})',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
