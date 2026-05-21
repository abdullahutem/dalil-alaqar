import '../../domain/entities/property_details_response_entity.dart';
import 'property_details_model.dart';

class PropertyDetailsResponseModel extends PropertyDetailsResponseEntity {
  const PropertyDetailsResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory PropertyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsResponseModel(
      success: (json['success'] as bool?) ?? false,
      message: json['message'] as String? ?? '',
      data: PropertyDetailsModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );
  }
}
