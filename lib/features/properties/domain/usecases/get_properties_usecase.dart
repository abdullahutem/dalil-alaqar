import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/repositories/properties_repository.dart';

class GetPropertiesUseCase {
  final PropertiesRepository repository;

  GetPropertiesUseCase({required this.repository});

  Future<Either<Failure, PropertiesResponseEntity>> call({
    int page = 1,
    int perPage = 20,
  }) async {
    return await repository.getProperties(page: page, perPage: perPage);
  }
}
