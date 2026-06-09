import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/theme/app_colors.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_cubit.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_state.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/widgets/offer_type_filter_chip.dart';

/// Example screen demonstrating how to use the Offer Types feature
class OfferTypesExampleScreen extends StatefulWidget {
  const OfferTypesExampleScreen({super.key});

  @override
  State<OfferTypesExampleScreen> createState() =>
      _OfferTypesExampleScreenState();
}

class _OfferTypesExampleScreenState extends State<OfferTypesExampleScreen> {
  int? selectedOfferTypeId;

  @override
  void initState() {
    super.initState();
    // Load offer types when screen initializes
    context.read<OfferTypesCubit>().getOfferTypes();
  }

  IconData _getIconForOfferType(String name) {
    if (name.contains('للبيع')) {
      return Icons.sell;
    } else if (name.contains('للإيجار')) {
      return Icons.key;
    } else if (name.contains('للاستثمار')) {
      return Icons.trending_up;
    }
    return Icons.home_work;
  }

  Color _getColorForOfferType(String name) {
    if (name.contains('للبيع')) {
      return Colors.green;
    } else if (name.contains('للإيجار')) {
      return Colors.blue;
    } else if (name.contains('للاستثمار')) {
      return Colors.orange;
    }
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('أنواع العروض'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<OfferTypesCubit, OfferTypesState>(
        builder: (context, state) {
          if (state is OfferTypesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OfferTypesError) {
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
                      context.read<OfferTypesCubit>().getOfferTypes();
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is OfferTypesSuccess) {
            final offerTypes = state.response.offerTypes;

            if (offerTypes.isEmpty) {
              return const Center(child: Text('لا توجد أنواع عروض متاحة'));
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
                          'اختر نوع العرض:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: offerTypes.map((offerType) {
                            return OfferTypeFilterChip(
                              offerType: offerType,
                              isSelected: selectedOfferTypeId == offerType.id,
                              onTap: () {
                                setState(() {
                                  if (selectedOfferTypeId == offerType.id) {
                                    selectedOfferTypeId = null;
                                  } else {
                                    selectedOfferTypeId = offerType.id;
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
                  // Grid view section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'جميع أنواع العروض:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.2,
                              ),
                          itemCount: offerTypes.length,
                          itemBuilder: (context, index) {
                            final offerType = offerTypes[index];
                            final color = _getColorForOfferType(offerType.name);
                            final icon = _getIconForOfferType(offerType.name);

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedOfferTypeId = offerType.id;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: selectedOfferTypeId == offerType.id
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          icon,
                                          size: 32,
                                          color: color,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        offerType.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: offerType.isActive
                                              ? Colors.green[100]
                                              : Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          offerType.isActive
                                              ? 'نشط'
                                              : 'غير نشط',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: offerType.isActive
                                                ? Colors.green[800]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                      ),
                                    ],
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
