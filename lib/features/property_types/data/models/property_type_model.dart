import 'package:dalil_alaqar/features/property_types/domain/entities/property_type_entity.dart';

class PropertyTypeModel extends PropertyTypeEntity {
  PropertyTypeModel({
    required super.id,
    required super.name,
    required super.icon,
    super.description,
    required super.order,
    required super.isActive,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      description: json['description'] as String?,
      order: json['order'] as int? ?? 0,
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
      'icon': icon,
      'description': description,
      'order': order,
      'is_active': isActive,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
