import 'package:dalil_alaqar/features/districts/domain/entities/district_entity.dart';

class DistrictsResponseEntity {
  final bool success;
  final String message;
  final List<DistrictEntity> districts;

  DistrictsResponseEntity({
    required this.success,
    required this.message,
    required this.districts,
  });
}
