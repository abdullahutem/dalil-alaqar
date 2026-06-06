import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/property_details_response_entity.dart';
import 'package:dartz/dartz.dart';
import '../entities/office_properties_response_entity.dart';
import '../entities/property_stats_entity.dart';

abstract class OfficePropertiesRepository {
  Future<Either<Failure, OfficePropertiesResponseEntity>> getOfficeProperties({
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
  });

  Future<Either<Failure, PropertyStatsEntity>> getPropertyStats();

  Future<Either<Failure, String>> deleteProperty(int propertyId);
  Future<Either<Failure, PropertyDetailsResponseEntity>> getPropertyDetails({
    required int propertyId,
  });
}
