import 'property_image_entity.dart';

class UploadImagesResponseEntity {
  final bool success;
  final String message;
  final List<PropertyImageEntity> data;

  const UploadImagesResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
