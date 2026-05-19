import 'package:dalil_alaqar/features/property_types/data/models/property_type_model.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';

class PropertyTypesResponseModel extends PropertyTypesResponseEntity {
  PropertyTypesResponseModel({
    required super.success,
    required super.message,
    required super.propertyTypes,
  });

  factory PropertyTypesResponseModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      propertyTypes:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PropertyTypeModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': propertyTypes
          .map((type) => (type as PropertyTypeModel).toJson())
          .toList(),
    };
  }
}
