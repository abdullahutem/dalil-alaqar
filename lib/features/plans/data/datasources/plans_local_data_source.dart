import 'dart:convert';
import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dalil_alaqar/features/plans/data/models/plan_model.dart';
import 'package:dalil_alaqar/features/plans/data/models/plan_limits_model.dart';
import 'package:dalil_alaqar/features/plans/data/models/plan_prices_model.dart';

abstract class PlansLocalDataSource {
  Future<List<PlanModel>?> getCachedPlans();
  Future<void> cachePlans(List<PlanModel> plans);
  Future<void> clearPlans();
}

class PlansLocalDataSourceImpl extends BaseCachedDataSource
    implements PlansLocalDataSource {
  static const String _cacheKey = 'plans';
  static const Duration _defaultCacheAge = Duration(days: 30);

  PlansLocalDataSourceImpl({required DatabaseHelper databaseHelper})
    : super(databaseHelper: databaseHelper);

  /// Check if plans cache is valid
  Future<bool> _isCacheValid({Duration? maxAge}) async {
    return super.isCacheValid(_cacheKey, maxAge: maxAge);
  }

  @override
  Future<List<PlanModel>?> getCachedPlans() async {
    try {
      // Check if cache is valid first
      if (!await _isCacheValid()) {
        AppLogger.cache('Plans cache is invalid or expired', 'Plans');
        return null;
      }

      final db = await databaseHelper.database;
      final result = await db.query('plans', orderBy: 'priority_level ASC');

      if (result.isEmpty) {
        AppLogger.cache('No cached plans found', 'Plans');
        return null;
      }

      final plans = result.map((json) {
        return PlanModel(
          id: json['id'] as int,
          name: json['name'] as String,
          slug: json['slug'] as String,
          description: json['description'] as String,
          prices: PlanPricesModel.fromJson(
            jsonDecode(json['prices_json'] as String) as Map<String, dynamic>,
          ),
          limits: PlanLimitsModel.fromJson(
            jsonDecode(json['limits_json'] as String) as Map<String, dynamic>,
          ),
          features: List<String>.from(
            jsonDecode(json['features_json'] as String) as List<dynamic>,
          ),
          priorityLevel: json['priority_level'] as int,
          trialDays: json['trial_days'] as int,
          hasTrial: (json['has_trial'] as int) == 1,
        );
      }).toList();

      AppLogger.success('Loaded ${plans.length} plans from cache', 'Plans');
      return plans;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cached plans', 'Plans', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> cachePlans(List<PlanModel> plans) async {
    try {
      final db = await databaseHelper.database;

      AppLogger.database('Caching ${plans.length} plans', 'Plans');

      // Use transaction for atomicity
      await db.transaction((txn) async {
        // Clear existing plans
        await txn.delete('plans');

        // Insert new plans
        final cachedAt = DateTime.now().toIso8601String();
        for (final plan in plans) {
          await txn.insert('plans', {
            'id': plan.id,
            'name': plan.name,
            'slug': plan.slug,
            'description': plan.description,
            'prices_json': jsonEncode(
              (plan.prices as PlanPricesModel).toJson(),
            ),
            'limits_json': jsonEncode(
              (plan.limits as PlanLimitsModel).toJson(),
            ),
            'features_json': jsonEncode(plan.features),
            'priority_level': plan.priorityLevel,
            'trial_days': plan.trialDays,
            'has_trial': plan.hasTrial ? 1 : 0,
            'cached_at': cachedAt,
          });
        }

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success('Successfully cached ${plans.length} plans', 'Plans');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to cache plans', 'Plans', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> clearPlans() async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        await txn.delete('plans');
        // Clear cache metadata as well
        await txn.delete(
          'cache_metadata',
          where: 'key = ?',
          whereArgs: [_cacheKey],
        );
      });

      AppLogger.info('Cleared plans cache', 'Plans');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear plans cache', 'Plans', e, stackTrace);
      rethrow;
    }
  }
}
