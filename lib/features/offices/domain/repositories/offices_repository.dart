import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/offices_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class OfficesRepository {
  Future<Either<Failure, OfficesResponseEntity>> getOffices({
    required int page,
    required int perPage,
  });
}
