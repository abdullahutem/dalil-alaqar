import 'office_property_entity.dart';

class OfficePropertiesResponseEntity {
  final List<OfficePropertyEntity> properties;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const OfficePropertiesResponseEntity({
    required this.properties,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}
