import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/repositories/neighborhoods_repository.dart';

class GetNeighborhoodsByDistrictUseCase {
  final NeighborhoodsRepository repository;

  GetNeighborhoodsByDistrictUseCase({required this.repository});

  Future<Either<Failure, NeighborhoodsResponseEntity>> call(
    int districtId,
  ) async {
    return await repository.getNeighborhoodsByDistrict(districtId);
  }
}
