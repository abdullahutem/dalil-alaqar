import 'package:dalil_alaqar/core/databases/local/database_helper.dart';

abstract class PropertiesLocalDataSource {
  Future<String?> getCachedPropertiesJson();
  Future<void> cachePropertiesJson(String jsonData);
  Future<void> clearProperties();
}

class PropertiesLocalDataSourceImpl implements PropertiesLocalDataSource {
  final DatabaseHelper databaseHelper;

  PropertiesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String?> getCachedPropertiesJson() async {
    final db = await databaseHelper.database;
    final result = await db.query('properties_cache', limit: 1);

    if (result.isEmpty) {
      return null;
    }

    return result.first['data_json'] as String;
  }

  @override
  Future<void> cachePropertiesJson(String jsonData) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching properties list to database');

      // Clear existing cache
      await db.delete('properties_cache');

      // Insert new cache
      final cachedAt = DateTime.now().toIso8601String();
      await db.insert('properties_cache', {
        'id': 1, // Single row cache
        'data_json': jsonData,
        'cached_at': cachedAt,
      });

      print('✅ Successfully cached properties list');
    } catch (e, stackTrace) {
      print('❌ Error caching properties: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearProperties() async {
    final db = await databaseHelper.database;
    await db.delete('properties_cache');
  }
}
