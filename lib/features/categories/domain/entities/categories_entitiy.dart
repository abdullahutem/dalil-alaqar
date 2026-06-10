class CategoriesEntity {
  final List<CategoryEntity> categories;
  final PaginationEntity? pagination;

  CategoriesEntity({required this.categories, this.pagination});
}

class PaginationEntity {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  bool get hasMorePages => currentPage < lastPage;
}

class CategoryEntity {
  final int id;
  final String name;
  final String nameAr;
  final String? imageUrl;
  final String? thumbnailUrl;
  final int productsCount;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    this.imageUrl,
    this.thumbnailUrl,
    required this.productsCount,
  });
}
