import '../../domain/entities/category_products_entity.dart';

class CategoryProductsModel extends CategoryProductsEntity {
  CategoryProductsModel({
    required super.category,
    required super.products,
    required super.pagination,
  });

  factory CategoryProductsModel.fromJson(Map<String, dynamic> json) {
    // Handle response wrapper
    final data = json['data'] ?? json;

    return CategoryProductsModel(
      category: data['category'] != null
          ? CategoryDetailModel.fromJson(
              data['category'] as Map<String, dynamic>,
            )
          : null,
      products:
          (data['products'] as List<dynamic>?)
              ?.map(
                (e) => CategoryProductModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: data['pagination'] != null
          ? PaginationModel.fromJson(data['pagination'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CategoryDetailModel extends CategoryDetailEntity {
  CategoryDetailModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.imageUrl,
    super.thumbnailUrl,
  });

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    return CategoryDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      imageUrl: json['image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );
  }
}

class CategoryProductModel extends CategoryProductEntity {
  CategoryProductModel({
    required super.id,
    required super.name,
    required super.nameAr,
    required super.description,
    required super.descriptionAr,
    required super.price,
    super.originalPrice,
    super.discountPercent,
    super.imageUrl,
    super.thumbnailUrl,
    required super.hasVariants,
    required super.hasModifiers,
    required super.isBundle,
    super.calories,
    required super.preparationTime,
    super.currency,
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) {
    return CategoryProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      description: json['description'] as String? ?? '',
      descriptionAr: json['description_ar'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
      imageUrl: json['image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      hasVariants: json['has_variants'] as bool? ?? false,
      hasModifiers: json['has_modifiers'] as bool? ?? false,
      isBundle: json['is_bundle'] as bool? ?? false,
      calories: json['calories'] as String?,
      preparationTime: json['preparation_time'] as int? ?? 0,
      currency: json['currency'] != null
          ? CurrencyModel.fromJson(json['currency'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    required super.id,
    super.code,
    required super.symbol,
    required super.name,
    required super.decimalPlaces,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as int,
      code: json['code'] as String?,
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      decimalPlaces: json['decimal_places'] as int? ?? 2,
    );
  }
}

class PaginationModel extends PaginationEntity {
  PaginationModel({
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}
