class CategoryProductsEntity {
  final CategoryDetailEntity? category;
  final List<CategoryProductEntity> products;
  final PaginationEntity? pagination;

  CategoryProductsEntity({
    required this.category,
    required this.products,
    required this.pagination,
  });
}

class CategoryDetailEntity {
  final int id;
  final String name;
  final String nameAr;
  final String? imageUrl;
  final String? thumbnailUrl;

  CategoryDetailEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    this.imageUrl,
    this.thumbnailUrl,
  });
}

class CategoryProductEntity {
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final double? originalPrice;
  final double? discountPercent;
  final String? imageUrl;
  final String? thumbnailUrl;
  final bool hasVariants;
  final bool hasModifiers;
  final bool isBundle;
  final String? calories;
  final int preparationTime;
  final CurrencyEntity? currency;

  CategoryProductEntity({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    this.originalPrice,
    this.discountPercent,
    this.imageUrl,
    this.thumbnailUrl,
    required this.hasVariants,
    required this.hasModifiers,
    required this.isBundle,
    this.calories,
    required this.preparationTime,
    this.currency,
  });
}

class CurrencyEntity {
  final int id;
  final String? code;
  final String symbol;
  final String name;
  final int decimalPlaces;

  CurrencyEntity({
    required this.id,
    this.code,
    required this.symbol,
    required this.name,
    required this.decimalPlaces,
  });
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
}
