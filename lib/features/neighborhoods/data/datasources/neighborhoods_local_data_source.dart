import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/models/neighborhood_model.dart';

abstract class NeighborhoodsLocalDataSource {
  Future<List<NeighborhoodModel>> getCachedNeighborhoodsByDistrict(
    int districtId,
  );
  Future<void> cacheNeighborhoodsByDistrict(
    int districtId,
    List<NeighborhoodModel> neighborhoods,
  );
  Future<void> clearNeighborhoodsByDistrict(int districtId);
  Future<void> clearAllNeighborhoods();
}

class NeighborhoodsLocalDataSourceImpl implements NeighborhoodsLocalDataSource {
  final DatabaseHelper databaseHelper;

  NeighborhoodsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<NeighborhoodModel>> getCachedNeighborhoodsByDistrict(
    int districtId,
  ) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'neighborhoods',
      where: 'district_id = ?',
      whereArgs: [districtId],
      orderBy: 'name_ar ASC',
    );

    return result.map((json) {
      return NeighborhoodModel(
        id: json['id'] as int,
        nameAr: json['name_ar'] as String,
        nameEn: json['name_en'] as String,
        isActive: (json['is_active'] as int) == 1,
        districtId: json['district_id'] as int,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        deletedAt: json['deleted_at'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> cacheNeighborhoodsByDistrict(
    int districtId,
    List<NeighborhoodModel> neighborhoods,
  ) async {
    try {
      final db = await databaseHelper.database;

      print(
        '💾 Caching ${neighborhoods.length} neighborhoods for district $districtId',
      );

      // Clear existing neighborhoods for this district
      await db.delete(
        'neighborhoods',
        where: 'district_id = ?',
        whereArgs: [districtId],
      );

      // Insert new neighborhoods
      final cachedAt = DateTime.now().toIso8601String();
      for (final neighborhood in neighborhoods) {
        await db.insert('neighborhoods', {
          'id': neighborhood.id,
          'name_ar': neighborhood.nameAr,
          'name_en': neighborhood.nameEn,
          'is_active': neighborhood.isActive ? 1 : 0,
          'district_id': neighborhood.districtId,
          'created_by': neighborhood.createdBy,
          'updated_by': neighborhood.updatedBy,
          'created_at': neighborhood.createdAt,
          'updated_at': neighborhood.updatedAt,
          'deleted_at': neighborhood.deletedAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${neighborhoods.length} neighborhoods');
    } catch (e, stackTrace) {
      print('❌ Error caching neighborhoods: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearNeighborhoodsByDistrict(int districtId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'neighborhoods',
      where: 'district_id = ?',
      whereArgs: [districtId],
    );
  }

  @override
  Future<void> clearAllNeighborhoods() async {
    final db = await databaseHelper.database;
    await db.delete('neighborhoods');
  }
}
