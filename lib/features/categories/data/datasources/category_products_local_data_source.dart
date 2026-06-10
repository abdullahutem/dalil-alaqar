import 'package:food_delivery/features/categories/data/models/category_products_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/local/database_helper.dart';

abstract class CategoryProductsLocalDataSource {
  Future<void> cacheCategoryProducts(
    int categoryId,
    List<CategoryProductModel> products, {
    bool append = false,
  });
  Future<List<CategoryProductModel>?> getCachedCategoryProducts(int categoryId);
  Future<void> clearCategoryProductsCache(int categoryId);
  Future<bool> isCacheValid(String cacheKey, {Duration? maxAge});
}

class CategoryProductsLocalDataSourceImpl
    implements CategoryProductsLocalDataSource {
  final DatabaseHelper _databaseHelper;
  static const Duration _defaultCacheAge = Duration(days: 60);

  CategoryProductsLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  String _getCacheKey(int categoryId) => 'category_products_$categoryId';

  @override
  Future<void> cacheCategoryProducts(
    int categoryId,
    List<CategoryProductModel> products, {
    bool append = false,
  }) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear existing products for this category only if not appending
      if (!append) {
        await txn.delete(
          'category_products',
          where: 'category_id = ?',
          whereArgs: [categoryId],
        );
      }

      // Cache new products
      for (final product in products) {
        await txn.insert('category_products', {
          'id': product.id,
          'category_id': categoryId,
          'name': product.name,
          'name_ar': product.nameAr,
          'description': product.description,
          'description_ar': product.descriptionAr,
          'price': product.price,
          'original_price': product.originalPrice,
          'discount_percent': product.discountPercent,
          'image_url': product.imageUrl,
          'thumbnail_url': product.thumbnailUrl,
          'has_variants': product.hasVariants ? 1 : 0,
          'has_modifiers': product.hasModifiers ? 1 : 0,
          'is_bundle': product.isBundle ? 1 : 0,
          'calories': product.calories,
          'preparation_time': product.preparationTime,
          'currency_id': product.currency?.id,
          'currency_code': product.currency?.code,
          'currency_symbol': product.currency?.symbol,
          'currency_name': product.currency?.name,
          'currency_decimal_places': product.currency?.decimalPlaces,
          'cached_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      // Update cache metadata
      await txn.insert('cache_metadata', {
        'key': _getCacheKey(categoryId),
        'last_updated': now,
        'expires_at': now + _defaultCacheAge.inMilliseconds,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<List<CategoryProductModel>?> getCachedCategoryProducts(
    int categoryId,
  ) async {
    final db = await _databaseHelper.database;

    // Check if cache is valid
    if (!await isCacheValid(_getCacheKey(categoryId))) {
      return null;
    }

    // Get products for this category
    final result = await db.query(
      'category_products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: 'id ASC',
    );

    if (result.isEmpty) {
      return null;
    }

    return result
        .map(
          (productData) => CategoryProductModel(
            id: productData['id'] as int,
            name: productData['name'] as String,
            nameAr: productData['name_ar'] as String,
            description: productData['description'] as String,
            descriptionAr: productData['description_ar'] as String,
            price: productData['price'] as double,
            originalPrice: productData['original_price'] as double?,
            discountPercent: productData['discount_percent'] as double?,
            imageUrl: productData['image_url'] as String?,
            thumbnailUrl: productData['thumbnail_url'] as String?,
            hasVariants: (productData['has_variants'] as int) == 1,
            hasModifiers: (productData['has_modifiers'] as int) == 1,
            isBundle: (productData['is_bundle'] as int) == 1,
            calories: productData['calories'] as String?,
            preparationTime: productData['preparation_time'] as int,
            currency: productData['currency_id'] != null
                ? CurrencyModel(
                    id: productData['currency_id'] as int,
                    code: productData['currency_code'] as String?,
                    symbol: productData['currency_symbol'] as String,
                    name: productData['currency_name'] as String,
                    decimalPlaces:
                        productData['currency_decimal_places'] as int,
                  )
                : null,
          ),
        )
        .toList();
  }

  @override
  Future<void> clearCategoryProductsCache(int categoryId) async {
    final db = await _databaseHelper.database;
    await db.delete(
      'category_products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
    );
    await db.delete(
      'cache_metadata',
      where: 'key = ?',
      whereArgs: [_getCacheKey(categoryId)],
    );
  }

  @override
  Future<bool> isCacheValid(String cacheKey, {Duration? maxAge}) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final result = await db.query(
      'cache_metadata',
      where: 'key = ?',
      whereArgs: [cacheKey],
    );

    if (result.isEmpty) {
      return false;
    }

    final cacheData = result.first;
    final expiresAt = cacheData['expires_at'] as int?;

    if (expiresAt != null && now > expiresAt) {
      return false;
    }

    if (maxAge != null) {
      final lastUpdated = cacheData['last_updated'] as int;
      final ageLimit = lastUpdated + maxAge.inMilliseconds;
      return now <= ageLimit;
    }

    return true;
  }
}
