import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/core/constants/app_colors.dart';
import 'package:food_delivery/core/localization/localized_helper.dart';
import '../../domain/entities/categories_entitiy.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';

class CategoriesHorizontalList extends StatefulWidget {
  final Function(CategoryEntity)? onCategorySelected;
  final VoidCallback? onViewAllPressed;

  const CategoriesHorizontalList({
    super.key,
    this.onCategorySelected,
    this.onViewAllPressed,
  });

  @override
  State<CategoriesHorizontalList> createState() =>
      _CategoriesHorizontalListState();
}

class _CategoriesHorizontalListState extends State<CategoriesHorizontalList> {
  int? selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return Container(
            height: 110,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (state is CategoriesError) {
          return Container(
            height: 110,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.isArabic
                      ? 'خطأ في تحميل الفئات'
                      : "Error loading categories",
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.read<CategoriesCubit>().fetchCategories();
                  },
                  child: Text(context.isArabic ? 'إعادة المحاولة' : "Retry"),
                ),
              ],
            ),
          );
        }

        if (state is CategoriesLoaded) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          context.isArabic ? 'التصنيفات' : "Categories",

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (widget.onViewAllPressed != null)
                      TextButton(
                        onPressed: widget.onViewAllPressed,
                        child: Text(
                          context.isArabic ? "عرض الكل" : "View All",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 60,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const horizontalPadding = 12 * 2;
                    const itemSpacing = 4 * 2;
                    const itemsPerScreen = 3;

                    final availableWidth =
                        constraints.maxWidth - horizontalPadding;
                    final itemWidth =
                        (availableWidth / itemsPerScreen) - itemSpacing;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final bool isSelected =
                            selectedCategoryId == category.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoryId = category.id;
                            });
                            widget.onCategorySelected?.call(category);
                          },
                          child: Container(
                            width: itemWidth, // ✅ responsive width
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withOpacity(0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey[300]!,
                                width: isSelected ? 2 : 0.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox.expand(
                                child:
                                    (category.thumbnailUrl ??
                                            category.imageUrl) !=
                                        null
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            category.thumbnailUrl ??
                                            category.imageUrl!,
                                        fit: BoxFit.fill,
                                        memCacheHeight: 120,
                                        memCacheWidth: 200,
                                        fadeInDuration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        fadeOutDuration: const Duration(
                                          milliseconds: 100,
                                        ),
                                        placeholder: (context, url) =>
                                            Container(
                                              color: Colors.grey[200],
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/logo.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              color: Colors.grey[100],
                                              alignment: Alignment.center,
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/logo.png',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                      )
                                    : Container(
                                        color: Colors.grey[100],
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          size: 24,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
