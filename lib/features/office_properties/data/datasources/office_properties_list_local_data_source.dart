import 'package:dalil_alaqar/core/databases/local/database_helper.dart';

abstract class OfficePropertiesListLocalDataSource {
  Future<String?> getCachedOfficePropertiesJson();
  Future<void> cacheOfficePropertiesJson(String jsonData);
  Future<void> clearOfficeProperties();
}

class OfficePropertiesListLocalDataSourceImpl
    implements OfficePropertiesListLocalDataSource {
  final DatabaseHelper databaseHelper;

  OfficePropertiesListLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String?> getCachedOfficePropertiesJson() async {
    final db = await databaseHelper.database;
    final result = await db.query('office_properties_cache', limit: 1);

    if (result.isEmpty) {
      return null;
    }

    return result.first['data_json'] as String;
  }

  @override
  Future<void> cacheOfficePropertiesJson(String jsonData) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching office properties list to database');

      // Clear existing cache
      await db.delete('office_properties_cache');

      // Insert new cache
      final cachedAt = DateTime.now().toIso8601String();
      await db.insert('office_properties_cache', {
        'id': 1, // Single row cache
        'data_json': jsonData,
        'cached_at': cachedAt,
      });

      print('✅ Successfully cached office properties list');
    } catch (e, stackTrace) {
      print('❌ Error caching office properties: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearOfficeProperties() async {
    final db = await databaseHelper.database;
    await db.delete('office_properties_cache');
  }
}
