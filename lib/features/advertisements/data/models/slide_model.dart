import 'package:dalil_alaqar/features/advertisements/domain/entities/slide_entity.dart';

class SlideModel extends SlideEntity {
  SlideModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.link,
    required super.position,
    required super.order,
    super.officeId, // Optional
    required super.startDate,
    required super.endDate,
    required super.viewsCount,
    required super.clicksCount,
    required super.isActive,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 Parsing slide: ${json['id']} - ${json['title']}');

      return SlideModel(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        image: json['image'] as String? ?? '',
        link: json['link'] as String? ?? '',
        position: json['position'] as String? ?? 'top',
        order: json['order'] as int? ?? 0,
        officeId: json['office_id'] as int?, // Nullable
        startDate: json['start_date'] as String? ?? '',
        endDate: json['end_date'] as String? ?? '',
        viewsCount: json['views_count'] as int? ?? 0,
        clicksCount: json['clicks_count'] as int? ?? 0,
        isActive: json['is_active'] as bool? ?? false,
        status: json['status'] as String? ?? 'active',
        createdAt: json['created_at'] as String? ?? '',
        updatedAt: json['updated_at'] as String? ?? '',
      );
    } catch (e, stackTrace) {
      print('❌ Error parsing slide JSON: $e');
      print('❌ JSON data: $json');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'link': link,
      'position': position,
      'order': order,
      'office_id': officeId,
      'start_date': startDate,
      'end_date': endDate,
      'views_count': viewsCount,
      'clicks_count': clicksCount,
      'is_active': isActive,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
