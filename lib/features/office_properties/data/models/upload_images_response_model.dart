import '../../domain/entities/upload_images_response_entity.dart';
import 'property_image_model.dart';

class UploadImagesResponseModel extends UploadImagesResponseEntity {
  const UploadImagesResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory UploadImagesResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadImagesResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map(
            (item) => PropertyImageModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data
          .map((image) => (image as PropertyImageModel).toJson())
          .toList(),
    };
  }
}
