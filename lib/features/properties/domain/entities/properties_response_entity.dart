import 'package:dalil_alaqar/features/properties/domain/entities/property_entity.dart';

class PropertiesResponseEntity {
  final List<PropertyEntity> properties;
  final PaginationMeta meta;

  PropertiesResponseEntity({required this.properties, required this.meta});
}

class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}
