import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhood_entity.dart';

class NeighborhoodsResponseEntity {
  final bool success;
  final String message;
  final List<NeighborhoodEntity> neighborhoods;

  NeighborhoodsResponseEntity({
    required this.success,
    required this.message,
    required this.neighborhoods,
  });
}
