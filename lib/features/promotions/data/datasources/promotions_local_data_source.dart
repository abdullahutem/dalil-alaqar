import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/promotions/data/models/promotion_model.dart';

abstract class PromotionsLocalDataSource {
  Future<List<PromotionModel>> getCachedPromotions();
  Future<void> cachePromotions(List<PromotionModel> promotions);
  Future<void> clearPromotions();
}

class PromotionsLocalDataSourceImpl implements PromotionsLocalDataSource {
  final DatabaseHelper databaseHelper;

  PromotionsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<PromotionModel>> getCachedPromotions() async {
    final db = await databaseHelper.database;
    final result = await db.query('promotions', orderBy: 'id DESC');

    return result.map((json) {
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
  }

  @override
  Future<void> cachePromotions(List<PromotionModel> promotions) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${promotions.length} promotions to database');

      // Clear existing promotions
      await db.delete('promotions');

      // Insert new promotions
      final cachedAt = DateTime.now().toIso8601String();
      for (final promotion in promotions) {
        print('💾 Inserting promotion ${promotion.id}: ${promotion.title}');
        await db.insert('promotions', {
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

      print('✅ Successfully cached ${promotions.length} promotions');
    } catch (e, stackTrace) {
      print('❌ Error caching promotions: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearPromotions() async {
    final db = await databaseHelper.database;
    await db.delete('promotions');
  }
}
