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
    String? search,
    int? propertyTypeId,
    int? offerTypeId,
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
    double? minPrice,
    double? maxPrice,
  }) {
    return repository.getOfficeProperties(
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
