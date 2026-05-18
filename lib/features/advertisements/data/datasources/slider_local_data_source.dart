import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/advertisements/data/models/slide_model.dart';

abstract class SliderLocalDataSource {
  Future<List<SlideModel>> getCachedSlides();
  Future<void> cacheSlides(List<SlideModel> slides);
  Future<void> clearSlides();
}

class SliderLocalDataSourceImpl implements SliderLocalDataSource {
  final DatabaseHelper databaseHelper;

  SliderLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<SlideModel>> getCachedSlides() async {
    final db = await databaseHelper.database;
    final result = await db.query('slides', orderBy: 'id ASC');

    return result.map((json) {
      return SlideModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String,
        image: json['image'] as String,
        link: json['link'] as String,
        position: json['position'] as String,
        order: json['order'] as int,
        officeId: json['office_id'] as int?, // Nullable
        startDate: json['start_date'] as String,
        endDate: json['end_date'] as String,
        viewsCount: json['views_count'] as int,
        clicksCount: json['clicks_count'] as int,
        isActive: (json['is_active'] as int) == 1,
        status: json['status'] as String,
        createdAt: json['created_at'] as String,
        updatedAt: json['updated_at'] as String,
      );
    }).toList();
  }

  @override
  Future<void> cacheSlides(List<SlideModel> slides) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${slides.length} slides to database');

      // Clear existing slides
      await db.delete('slides');

      // Insert new slides
      final cachedAt = DateTime.now().toIso8601String();
      for (final slide in slides) {
        print('💾 Inserting slide ${slide.id}: ${slide.title}');
        await db.insert('slides', {
          'id': slide.id,
          'title': slide.title,
          'description': slide.description,
          'image': slide.image,
          'link': slide.link,
          'position': slide.position,
          'order': slide.order,
          'office_id': slide.officeId,
          'start_date': slide.startDate,
          'end_date': slide.endDate,
          'views_count': slide.viewsCount,
          'clicks_count': slide.clicksCount,
          'is_active': slide.isActive ? 1 : 0,
          'status': slide.status,
          'created_at': slide.createdAt,
          'updated_at': slide.updatedAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${slides.length} slides');
    } catch (e, stackTrace) {
      print('❌ Error caching slides: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearSlides() async {
    final db = await databaseHelper.database;
    await db.delete('slides');
  }
}
