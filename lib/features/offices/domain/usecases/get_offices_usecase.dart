import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/offices_response_entity.dart';
import 'package:dalil_alaqar/features/offices/domain/repositories/offices_repository.dart';
import 'package:dartz/dartz.dart';

class GetOfficesUseCase {
  final OfficesRepository repository;

  GetOfficesUseCase(this.repository);

  Future<Either<Failure, OfficesResponseEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repository.getOffices(page: page, perPage: perPage);
  }
}
