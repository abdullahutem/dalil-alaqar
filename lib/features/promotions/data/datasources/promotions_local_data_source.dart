import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dalil_alaqar/features/promotions/data/models/promotion_model.dart';

abstract class PromotionsLocalDataSource {
  Future<List<PromotionModel>?> getCachedPromotions();
  Future<void> cachePromotions(List<PromotionModel> promotions);
  Future<void> clearPromotions();
}

class PromotionsLocalDataSourceImpl extends BaseCachedDataSource
    implements PromotionsLocalDataSource {
  static const String _cacheKey = 'promotions';
  static const Duration _defaultCacheAge = Duration(days: 7);

  PromotionsLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : super(databaseHelper: databaseHelper);

  /// Check if promotions cache is valid
  Future<bool> _isCacheValid({Duration? maxAge}) async {
    return super.isCacheValid(_cacheKey, maxAge: maxAge);
  }

  @override
  Future<List<PromotionModel>?> getCachedPromotions() async {
    try {
      // Check if cache is valid first
      if (!await _isCacheValid()) {
        AppLogger.cache('Promotions cache is invalid or expired', 'Promotions');
        return null;
      }

      final db = await databaseHelper.database;
      final result = await db.query('promotions', orderBy: 'id DESC');

      if (result.isEmpty) {
        AppLogger.cache('No cached promotions found', 'Promotions');
        return null;
      }

      final promotions = result.map((json) {
        return PromotionModel(
          id: json['id'] as int,
          title: json['title'] as String,
          description: json['description'] as String?,
          image: json['image'] as String?,
          type: json['type'] as String,
          discountValue: json['discount_value'] != null
              ? double.tryParse(json['discount_value'].toString())
              : null,
          officeId: json['office_id'] as int?,
          propertyId: json['property_id'] as int?,
          planId: json['plan_id'] as int?,
          startDate: json['start_date'] as String?,
          endDate: json['end_date'] as String?,
          terms: json['terms'] as String?,
          maxUsage: json['max_usage'] as int?,
          usageCount: json['usage_count'] as int,
          isActive: (json['is_active'] as int) == 1,
          status: json['status'] as String?,
          createdAt: json['created_at'] as String?,
          updatedAt: json['updated_at'] as String?,
        );
      }).toList();

      AppLogger.success(
        'Loaded ${promotions.length} promotions from cache',
        'Promotions',
      );
      return promotions;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get cached promotions',
        'Promotions',
        e,
        stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> cachePromotions(List<PromotionModel> promotions) async {
    try {
      final db = await databaseHelper.database;

      AppLogger.database(
        'Caching ${promotions.length} promotions',
        'Promotions',
      );

      // Use transaction for atomicity
      await db.transaction((txn) async {
        // Clear existing promotions
        await txn.delete('promotions');

        // Insert new promotions
        final cachedAt = DateTime.now().toIso8601String();
        for (final promotion in promotions) {
          await txn.insert('promotions', {
            'id': promotion.id,
            'title': promotion.title,
            'description': promotion.description,
            'image': promotion.image,
            'type': promotion.type,
            'discount_value': promotion.discountValue,
            'office_id': promotion.officeId,
            'property_id': promotion.propertyId,
            'plan_id': promotion.planId,
            'start_date': promotion.startDate,
            'end_date': promotion.endDate,
            'terms': promotion.terms,
            'max_usage': promotion.maxUsage,
            'usage_count': promotion.usageCount,
            'is_active': promotion.isActive ? 1 : 0,
            'status': promotion.status,
            'created_at': promotion.createdAt,
            'updated_at': promotion.updatedAt,
            'cached_at': cachedAt,
          });
        }

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success(
        'Successfully cached ${promotions.length} promotions',
        'Promotions',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to cache promotions',
        'Promotions',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> clearPromotions() async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        await txn.delete('promotions');
        // Clear cache metadata as well
        await txn.delete(
          'cache_metadata',
          where: 'key = ?',
          whereArgs: [_cacheKey],
        );
      });

      AppLogger.info('Cleared promotions cache', 'Promotions');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear promotions cache',
        'Promotions',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
