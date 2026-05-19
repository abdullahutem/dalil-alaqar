import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';

abstract class DistrictsRepository {
  Future<Either<Failure, DistrictsResponseEntity>> getDistrictsByGovernorate(
    int governorateId,
  );
}
