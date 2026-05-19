import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';

abstract class PropertiesRepository {
  Future<Either<Failure, PropertiesResponseEntity>> getProperties({
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
  });

  Future<Either<Failure, PropertyDetailsEntity>> getPropertyDetails({
    required int id,
  });
}
