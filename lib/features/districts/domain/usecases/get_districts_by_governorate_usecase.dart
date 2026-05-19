import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';
import 'package:dalil_alaqar/features/districts/domain/repositories/districts_repository.dart';

class GetDistrictsByGovernorateUseCase {
  final DistrictsRepository repository;

  GetDistrictsByGovernorateUseCase({required this.repository});

  Future<Either<Failure, DistrictsResponseEntity>> call(
    int governorateId,
  ) async {
    return await repository.getDistrictsByGovernorate(governorateId);
  }
}
