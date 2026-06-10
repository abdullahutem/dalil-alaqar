import 'package:food_delivery/features/categories/data/models/categories_model.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/database/local/database_helper.dart';

abstract class CategoriesLocalDataSource {
  Future<void> cacheCategories(
    List<CategoryModel> categories, {
    bool append = false,
  });
  Future<List<CategoryModel>?> getCachedCategories();
  Future<void> clearCategoriesCache();
  Future<bool> isCacheValid(String cacheKey, {Duration? maxAge});
}

class CategoriesLocalDataSourceImpl implements CategoriesLocalDataSource {
  final DatabaseHelper _databaseHelper;
  static const String _cacheKey = 'categories';
  static const Duration _defaultCacheAge = Duration(days: 60);

  CategoriesLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : _databaseHelper = databaseHelper;

  @override
  Future<void> cacheCategories(
    List<CategoryModel> categories, {
    bool append = false,
  }) async {
    final db = await _databaseHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    await db.transaction((txn) async {
      // Clear existing categories only if not appending
      if (!append) {
        await txn.delete('categories');
      }

      // Cache new categories
      for (final category in categories) {
        await txn.insert('categories', {
          'id': category.id,
          'name': category.name,
          'name_ar': category.nameAr,
          'image_url': category.imageUrl,
          'thumbnail_url': category.thumbnailUrl,
          'products_count': category.productsCount,
          'cached_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }

      // Update cache metadata
      await txn.insert('cache_metadata', {
        'key': _cacheKey,
        'last_updated': now,
        'expires_at': now + _defaultCacheAge.inMilliseconds,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<List<CategoryModel>?> getCachedCategories() async {
    final db = await _databaseHelper.database;

    // Check if cache is valid
    if (!await isCacheValid(_cacheKey)) {
      return null;
    }

    // Get categories
    final result = await db.query('categories', orderBy: 'id ASC');

    if (result.isEmpty) {
      return null;
    }

    return result
        .map(
          (categoryData) => CategoryModel(
            id: categoryData['id'] as int,
            name: categoryData['name'] as String,
            nameAr: categoryData['name_ar'] as String,
            imageUrl: categoryData['image_url'] as String?,
            thumbnailUrl: categoryData['thumbnail_url'] as String?,
            productsCount: categoryData['products_count'] as int,
          ),
        )
        .toList();
  }

  @override
  Future<void> clearCategoriesCache() async {
    final db = await _databaseHelper.database;
    await db.delete('categories');
    await db.delete('cache_metadata', where: 'key = ?', whereArgs: [_cacheKey]);
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
