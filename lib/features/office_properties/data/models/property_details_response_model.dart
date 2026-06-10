import '../../domain/entities/property_details_response_entity.dart';
import 'property_details_model.dart';

class PropertyDetailsResponseModel extends PropertyDetailsResponseEntity {
  const PropertyDetailsResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory PropertyDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];

    if (dataJson == null) {
      throw Exception('Property data is null in response');
    }

    return PropertyDetailsResponseModel(
      success: (json['success'] as bool?) ?? false,
      message: json['message'] as String? ?? '',
      data: PropertyDetailsModel.fromJson(dataJson as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as PropertyDetailsModel).toJson(),
    };
  }
}
