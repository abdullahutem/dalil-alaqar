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
    String? search,
    int? propertyTypeId,
    int? offerTypeId,
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
    double? minPrice,
    double? maxPrice,
  }) async {
    return await repository.getProperties(
      page: page,
      perPage: perPage,
      search: search,
      propertyTypeId: propertyTypeId,
      offerTypeId: offerTypeId,
      governorateId: governorateId,
      districtId: districtId,
      neighborhoodId: neighborhoodId,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}
