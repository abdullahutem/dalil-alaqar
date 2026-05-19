import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';

abstract class PropertyTypesRepository {
  Future<Either<Failure, PropertyTypesResponseEntity>> getPropertyTypes();
}
