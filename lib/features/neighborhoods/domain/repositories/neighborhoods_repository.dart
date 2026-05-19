import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';

abstract class NeighborhoodsRepository {
  Future<Either<Failure, NeighborhoodsResponseEntity>>
  getNeighborhoodsByDistrict(int districtId);
}
