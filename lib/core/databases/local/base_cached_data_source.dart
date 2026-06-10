import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:sqflite/sqflite.dart';

/// Base class for local data sources with cache validation
abstract class BaseCachedDataSource {
  final DatabaseHelper databaseHelper;

  BaseCachedDataSource({required this.databaseHelper});

  /// Check if cache is valid based on cache_metadata table
  ///
  /// [cacheKey] - Unique key for this cache (e.g., 'promotions', 'offices')
  /// [maxAge] - Optional custom max age. If not provided, checks expires_at from metadata
  Future<bool> isCacheValid(String cacheKey, {Duration? maxAge}) async {
    final db = await databaseHelper.database;
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

    // Check if cache has expired based on expires_at
    if (expiresAt != null && now > expiresAt) {
      return false;
    }

    // If custom maxAge is provided, check against last_updated
    if (maxAge != null) {
      final lastUpdated = cacheData['last_updated'] as int;
      final ageLimit = lastUpdated + maxAge.inMilliseconds;
      return now <= ageLimit;
    }

    return true;
  }

  /// Update cache metadata
  ///
  /// [txn] - Transaction to use (ensures atomicity)
  /// [cacheKey] - Unique key for this cache
  /// [defaultCacheAge] - How long the cache should be valid
  Future<void> updateCacheMetadata(
    Transaction txn,
    String cacheKey,
    Duration defaultCacheAge,
  ) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await txn.insert('cache_metadata', {
      'key': cacheKey,
      'last_updated': now,
      'expires_at': now + defaultCacheAge.inMilliseconds,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Clear cache metadata for a specific key
  Future<void> clearCacheMetadata(String cacheKey) async {
    final db = await databaseHelper.database;
    await db.delete('cache_metadata', where: 'key = ?', whereArgs: [cacheKey]);
  }

  /// Get cache age in milliseconds
  Future<int?> getCacheAge(String cacheKey) async {
    final db = await databaseHelper.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final result = await db.query(
      'cache_metadata',
      where: 'key = ?',
      whereArgs: [cacheKey],
    );

    if (result.isEmpty) {
      return null;
    }

    final lastUpdated = result.first['last_updated'] as int;
    return now - lastUpdated;
  }
}
