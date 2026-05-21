import '../../domain/entities/property_image_entity.dart';

class PropertyImageModel extends PropertyImageEntity {
  const PropertyImageModel({
    required super.id,
    required super.imagePath,
    required super.imageUrl,
    required super.isPrimary,
    required super.order,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] as int,
      imagePath: json['image_path'] as String,
      imageUrl: json['image_url'] as String,
      isPrimary: json['is_primary'] as bool,
      order: json['order'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'image_url': imageUrl,
      'is_primary': isPrimary,
      'order': order,
    };
  }
}
