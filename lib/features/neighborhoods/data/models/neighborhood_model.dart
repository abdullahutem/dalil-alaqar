import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhood_entity.dart';

class NeighborhoodModel extends NeighborhoodEntity {
  NeighborhoodModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.isActive,
    required super.districtId,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      districtId: json['district_id'] as int,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'is_active': isActive,
      'district_id': districtId,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
