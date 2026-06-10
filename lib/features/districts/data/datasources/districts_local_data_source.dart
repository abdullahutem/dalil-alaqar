import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/districts/data/models/district_model.dart';

abstract class DistrictsLocalDataSource {
  Future<List<DistrictModel>> getCachedDistrictsByGovernorate(
    int governorateId,
  );
  Future<void> cacheDistrictsByGovernorate(
    int governorateId,
    List<DistrictModel> districts,
  );
  Future<void> clearDistrictsByGovernorate(int governorateId);
  Future<void> clearAllDistricts();
}

class DistrictsLocalDataSourceImpl implements DistrictsLocalDataSource {
  final DatabaseHelper databaseHelper;

  DistrictsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<DistrictModel>> getCachedDistrictsByGovernorate(
    int governorateId,
  ) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'districts',
      where: 'governorate_id = ?',
      whereArgs: [governorateId],
      orderBy: 'name_ar ASC',
    );

    return result.map((json) {
      return DistrictModel(
        id: json['id'] as int,
        nameAr: json['name_ar'] as String,
        nameEn: json['name_en'] as String,
        isActive: (json['is_active'] as int) == 1,
        governorateId: json['governorate_id'] as int,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        deletedAt: json['deleted_at'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> cacheDistrictsByGovernorate(
    int governorateId,
    List<DistrictModel> districts,
  ) async {
    try {
      final db = await databaseHelper.database;

      print(
        '💾 Caching ${districts.length} districts for governorate $governorateId',
      );

      // Clear existing districts for this governorate
      await db.delete(
        'districts',
        where: 'governorate_id = ?',
        whereArgs: [governorateId],
      );

      // Insert new districts
      final cachedAt = DateTime.now().toIso8601String();
      for (final district in districts) {
        await db.insert('districts', {
          'id': district.id,
          'name_ar': district.nameAr,
          'name_en': district.nameEn,
          'is_active': district.isActive ? 1 : 0,
          'governorate_id': district.governorateId,
          'created_by': district.createdBy,
          'updated_by': district.updatedBy,
          'created_at': district.createdAt,
          'updated_at': district.updatedAt,
          'deleted_at': district.deletedAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${districts.length} districts');
    } catch (e, stackTrace) {
      print('❌ Error caching districts: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearDistrictsByGovernorate(int governorateId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'districts',
      where: 'governorate_id = ?',
      whereArgs: [governorateId],
    );
  }

  @override
  Future<void> clearAllDistricts() async {
    final db = await databaseHelper.database;
    await db.delete('districts');
  }
}
