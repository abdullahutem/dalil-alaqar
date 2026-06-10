import 'package:dalil_alaqar/core/databases/local/database_helper.dart';

abstract class OfficePropertyDetailsLocalDataSource {
  Future<String?> getCachedPropertyDetails(int propertyId);
  Future<void> cachePropertyDetails(int propertyId, String jsonData);
  Future<void> clearPropertyDetails(int propertyId);
  Future<void> clearAllPropertyDetails();
}

class OfficePropertyDetailsLocalDataSourceImpl
    implements OfficePropertyDetailsLocalDataSource {
  final DatabaseHelper databaseHelper;

  OfficePropertyDetailsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String?> getCachedPropertyDetails(int propertyId) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'office_property_details_cache',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first['details_json'] as String;
  }

  @override
  Future<void> cachePropertyDetails(int propertyId, String jsonData) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching office property details for property ID: $propertyId');

      final cachedAt = DateTime.now().toIso8601String();

      // Delete existing cache for this property
      await db.delete(
        'office_property_details_cache',
        where: 'property_id = ?',
        whereArgs: [propertyId],
      );

      // Insert new cache
      await db.insert('office_property_details_cache', {
        'property_id': propertyId,
        'details_json': jsonData,
        'cached_at': cachedAt,
      });

      print(
        '✅ Successfully cached office property details for property ID: $propertyId',
      );
    } catch (e, stackTrace) {
      print('❌ Error caching office property details: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearPropertyDetails(int propertyId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'office_property_details_cache',
      where: 'property_id = ?',
      whereArgs: [propertyId],
    );
  }

  @override
  Future<void> clearAllPropertyDetails() async {
    final db = await databaseHelper.database;
    await db.delete('office_property_details_cache');
  }
}
