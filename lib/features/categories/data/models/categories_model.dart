import '../../domain/entities/categories_entitiy.dart';

class CategoriesModel extends CategoriesEntity {
  CategoriesModel({required super.categories, super.pagination});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    // Handle the new response structure with "success" and "data" wrapper
    final data = json['data'] ?? json;

    return CategoriesModel(
      categories: (data['categories'] as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList(),
      pagination: data['pagination'] != null
          ? PaginationModel.fromJson(data['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': true,
      'data': {
        'categories': categories
            .map((category) => (category as CategoryModel).toJson())
            .toList(),
        if (pagination != null)
          'pagination': (pagination as PaginationModel).toJson(),
      },
    };
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

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.nameAr,
    super.imageUrl,
    super.thumbnailUrl,
    required super.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      imageUrl: json['image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      productsCount: json['products_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'image_url': imageUrl,
      'thumbnail_url': thumbnailUrl,
      'products_count': productsCount,
    };
  }
}
