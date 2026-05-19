import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';

abstract class PropertiesRepository {
  Future<Either<Failure, PropertiesResponseEntity>> getProperties({
    int page = 1,
    int perPage = 20,
  });
}
