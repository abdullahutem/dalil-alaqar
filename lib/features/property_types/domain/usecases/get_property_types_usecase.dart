import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';

class GetPropertyTypesUseCase {
  final PropertyTypesRepository repository;

  GetPropertyTypesUseCase({required this.repository});

  Future<Either<Failure, PropertyTypesResponseEntity>> call() async {
    return await repository.getPropertyTypes();
  }
}
