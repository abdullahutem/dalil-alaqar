import 'property_details_entity.dart';

class PropertyDetailsResponseEntity {
  final bool success;
  final String message;
  final PropertyDetailsEntity data;

  const PropertyDetailsResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
