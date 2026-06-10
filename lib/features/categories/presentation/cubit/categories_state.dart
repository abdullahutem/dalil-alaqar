import '../../domain/entities/categories_entitiy.dart';

abstract class CategoriesState {}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryEntity> categories;
  final PaginationEntity? pagination;
  final bool isLoadingMore;

  CategoriesLoaded({
    required this.categories,
    this.pagination,
    this.isLoadingMore = false,
  });

  CategoriesLoaded copyWith({
    List<CategoryEntity>? categories,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class CategoriesError extends CategoriesState {
  final String message;

  CategoriesError({required this.message});
}
