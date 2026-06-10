import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/governorates/data/models/governorate_model.dart';

abstract class GovernoratesLocalDataSource {
  Future<List<GovernorateModel>> getCachedGovernorates();
  Future<void> cacheGovernorates(List<GovernorateModel> governorates);
  Future<void> clearGovernorates();
}

class GovernoratesLocalDataSourceImpl implements GovernoratesLocalDataSource {
  final DatabaseHelper databaseHelper;

  GovernoratesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<GovernorateModel>> getCachedGovernorates() async {
    final db = await databaseHelper.database;
    final result = await db.query('governorates', orderBy: 'name_ar ASC');

    return result.map((json) {
      return GovernorateModel(
        id: json['id'] as int,
        nameAr: json['name_ar'] as String,
        nameEn: json['name_en'] as String,
        isActive: (json['is_active'] as int) == 1,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
        deletedAt: json['deleted_at'] as String?,
        districtsCount: json['districts_count'] as int,
      );
    }).toList();
  }

  @override
  Future<void> cacheGovernorates(List<GovernorateModel> governorates) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${governorates.length} governorates to database');

      // Clear existing governorates
      await db.delete('governorates');

      // Insert new governorates
      final cachedAt = DateTime.now().toIso8601String();
      for (final governorate in governorates) {
        print(
          '💾 Inserting governorate ${governorate.id}: ${governorate.nameAr}',
        );
        await db.insert('governorates', {
          'id': governorate.id,
          'name_ar': governorate.nameAr,
          'name_en': governorate.nameEn,
          'is_active': governorate.isActive ? 1 : 0,
          'created_by': governorate.createdBy,
          'updated_by': governorate.updatedBy,
          'created_at': governorate.createdAt,
          'updated_at': governorate.updatedAt,
          'deleted_at': governorate.deletedAt,
          'districts_count': governorate.districtsCount,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${governorates.length} governorates');
    } catch (e, stackTrace) {
      print('❌ Error caching governorates: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearGovernorates() async {
    final db = await databaseHelper.database;
    await db.delete('governorates');
  }
}
