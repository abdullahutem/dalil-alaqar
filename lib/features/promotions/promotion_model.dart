import '../../domain/entities/promotion_entity.dart';

class PromotionModel extends PromotionEntity {
  const PromotionModel({
    required super.id,
    required super.title,
    super.description,
    super.image,
    required super.type,
    super.discountValue,
    super.officeId,
    super.propertyId,
    super.planId,
    super.startDate,
    super.endDate,
    super.terms,
    super.maxUsage,
    required super.usageCount,
    required super.isActive,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      type: json['type'] as String? ?? 'percentage',
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
      usageCount: (json['usage_count'] as int?) ?? 0,
      isActive: (json['is_active'] as bool?) ?? false,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'image': image,
        'type': type,
        'discount_value': discountValue,
        'office_id': officeId,
        'property_id': propertyId,
        'plan_id': planId,
        'start_date': startDate,
        'end_date': endDate,
        'terms': terms,
        'max_usage': maxUsage,
        'usage_count': usageCount,
        'is_active': isActive,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}
