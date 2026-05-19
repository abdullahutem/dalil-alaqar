import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_type_entity.dart';

class OfferTypeModel extends OfferTypeEntity {
  OfferTypeModel({
    required super.id,
    required super.name,
    required super.isActive,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory OfferTypeModel.fromJson(Map<String, dynamic> json) {
    return OfferTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
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
      'name': name,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
