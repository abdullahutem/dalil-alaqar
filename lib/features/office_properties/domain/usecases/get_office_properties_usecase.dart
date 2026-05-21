import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/office_properties_response_entity.dart';
import '../repositories/office_properties_repository.dart';

class GetOfficePropertiesUseCase {
  final OfficePropertiesRepository repository;

  GetOfficePropertiesUseCase(this.repository);

  Future<Either<Failure, OfficePropertiesResponseEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repository.getOfficeProperties(page: page, perPage: perPage);
  }
}
