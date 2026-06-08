import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/create_property_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/property_details_response_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/update_property_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/upload_images_response_entity.dart';
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

  Future<Either<Failure, PropertyDetailsResponseEntity>> updatePropertyStatus({
    required int propertyId,
    required String status,
  });

  Future<Either<Failure, UploadImagesResponseEntity>> uploadPropertyImages({
    required int propertyId,
    required List<String> imagePaths,
  });

  Future<Either<Failure, String>> setPrimaryImage({
    required int propertyId,
    required int imageId,
  });

  Future<Either<Failure, String>> deletePropertyImage({
    required int propertyId,
    required int imageId,
  });

  Future<Either<Failure, PropertyDetailsResponseEntity>> createProperty({
    required CreatePropertyEntity property,
  });

  Future<Either<Failure, PropertyDetailsResponseEntity>> updateProperty({
    required UpdatePropertyEntity property,
  });
}
