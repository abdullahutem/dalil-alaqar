import 'package:food_delivery/features/categories/domain/entities/category_products_entity.dart';

abstract class CategoryProductsState {}

class CategoryProductsInitial extends CategoryProductsState {}

class CategoryProductsLoading extends CategoryProductsState {
  final int selectedCategoryId;
  final String selectedCategoryName;
  final String searchQuery;

  CategoryProductsLoading({
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    this.searchQuery = '',
  });
}

class CategoryProductsLoaded extends CategoryProductsState {
  final CategoryProductsEntity categoryProducts;
  final int selectedCategoryId;
  final String selectedCategoryName;
  final String searchQuery;
  final bool isLoadingProducts;

  CategoryProductsLoaded({
    required this.categoryProducts,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    this.searchQuery = '',
    this.isLoadingProducts = false,
  });

  CategoryProductsLoaded copyWith({
    CategoryProductsEntity? categoryProducts,
    int? selectedCategoryId,
    String? selectedCategoryName,
    String? searchQuery,
    bool? isLoadingProducts,
  }) {
    return CategoryProductsLoaded(
      categoryProducts: categoryProducts ?? this.categoryProducts,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
    );
  }
}

class CategoryProductsError extends CategoryProductsState {
  final String message;
  final int selectedCategoryId;
  final String selectedCategoryName;
  final String searchQuery;

  CategoryProductsError({
    required this.message,
    required this.selectedCategoryId,
    required this.selectedCategoryName,
    this.searchQuery = '',
  });
}
