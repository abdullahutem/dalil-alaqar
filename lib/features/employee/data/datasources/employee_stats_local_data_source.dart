import 'package:dalil_alaqar/core/databases/local/base_cached_data_source.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';

import '../models/employee_stats_model.dart';

abstract class EmployeeStatsLocalDataSource {
  /// Get cached employee stats
  Future<EmployeeStatsModel?> getCachedEmployeeStats();

  /// Cache employee stats
  Future<void> cacheEmployeeStats(EmployeeStatsModel stats);

  /// Clear cached employee stats
  Future<void> clearEmployeeStats();
}

class EmployeeStatsLocalDataSourceImpl extends BaseCachedDataSource
    implements EmployeeStatsLocalDataSource {
  static const String _cacheKey = 'employee_stats';
  static const Duration _defaultCacheAge = Duration(
    hours: 1,
  ); // Stats cached for 1 hour

  EmployeeStatsLocalDataSourceImpl({required super.databaseHelper});

  @override
  Future<EmployeeStatsModel?> getCachedEmployeeStats() async {
    try {
      final db = await databaseHelper.database;

      // Check if cache is valid
      final isValid = await isCacheValid(_cacheKey);
      if (!isValid) {
        AppLogger.cache('Employee stats cache expired', 'EmployeeStats');
        return null;
      }

      final result = await db.query('employee_stats', limit: 1);

      if (result.isEmpty) {
        AppLogger.cache('No cached employee stats found', 'EmployeeStats');
        return null;
      }

      final data = result.first;
      final stats = EmployeeStatsModel(
        total: data['total'] as int,
        active: data['active'] as int,
        inactive: data['inactive'] as int,
        canAddMore: (data['can_add_more'] as int) == 1,
      );

      AppLogger.success(
        'Loaded employee stats from cache (total: ${stats.total})',
        'EmployeeStats',
      );
      return stats;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error loading cached employee stats',
        'EmployeeStats',
        e,
        stackTrace,
      );
      return null;
    }
  }

  @override
  Future<void> cacheEmployeeStats(EmployeeStatsModel stats) async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        // Clear existing stats
        await txn.delete('employee_stats');

        // Insert new stats
        await txn.insert('employee_stats', {
          'id': 1, // Single row for stats
          'total': stats.total,
          'active': stats.active,
          'inactive': stats.inactive,
          'can_add_more': stats.canAddMore ? 1 : 0,
          'cached_at': DateTime.now().toIso8601String(),
        });

        // Update cache metadata
        await updateCacheMetadata(txn, _cacheKey, _defaultCacheAge);
      });

      AppLogger.success(
        'Cached employee stats (total: ${stats.total}, active: ${stats.active})',
        'EmployeeStats',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error caching employee stats',
        'EmployeeStats',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> clearEmployeeStats() async {
    try {
      final db = await databaseHelper.database;

      await db.transaction((txn) async {
        await txn.delete('employee_stats');
      });

      await clearCacheMetadata(_cacheKey);

      AppLogger.info('Cleared employee stats cache', 'EmployeeStats');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error clearing employee stats cache',
        'EmployeeStats',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
