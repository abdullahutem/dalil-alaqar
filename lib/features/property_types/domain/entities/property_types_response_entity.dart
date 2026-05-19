import 'package:dalil_alaqar/features/property_types/domain/entities/property_type_entity.dart';

class PropertyTypesResponseEntity {
  final bool success;
  final String message;
  final List<PropertyTypeEntity> propertyTypes;

  PropertyTypesResponseEntity({
    required this.success,
    required this.message,
    required this.propertyTypes,
  });
}
