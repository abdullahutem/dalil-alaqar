import 'office_entity.dart';

class OfficesResponseEntity {
  final bool success;
  final String message;
  final List<OfficeEntity> data;
  final MetaEntity meta;

  const OfficesResponseEntity({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });
}

class MetaEntity {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const MetaEntity({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}
