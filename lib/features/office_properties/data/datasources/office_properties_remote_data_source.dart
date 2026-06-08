import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/office_properties/data/models/property_details_response_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/create_property_model.dart';
import '../models/office_properties_response_model.dart';
import '../models/property_stats_model.dart';
import '../models/upload_images_response_model.dart';

abstract class OfficePropertiesRemoteDataSource {
  Future<OfficePropertiesResponseModel> getOfficeProperties({
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
  Future<PropertyDetailsResponseModel> getPropertyDetails({
    required int propertyId,
  });

  Future<PropertyStatsModel> getPropertyStats();

  Future<String> deleteProperty(int propertyId);

  Future<PropertyDetailsResponseModel> updatePropertyStatus({
    required int propertyId,
    required String status,
  });

  Future<UploadImagesResponseModel> uploadPropertyImages({
    required int propertyId,
    required List<String> imagePaths,
  });

  Future<String> setPrimaryImage({
    required int propertyId,
    required int imageId,
  });

  Future<String> deletePropertyImage({
    required int propertyId,
    required int imageId,
  });

  Future<PropertyDetailsResponseModel> createProperty({
    required CreatePropertyModel property,
  });

  Future<PropertyDetailsResponseModel> updateProperty({
    required int propertyId,
    required Map<String, dynamic> data,
  });
}

class OfficePropertiesRemoteDataSourceImpl
    implements OfficePropertiesRemoteDataSource {
  ApiConsumer apiConsumer;
  OfficePropertiesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficePropertiesResponseModel> getOfficeProperties({
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
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }
    if (propertyTypeId != null) {
      queryParameters['property_type_id'] = propertyTypeId;
    }
    if (offerTypeId != null) {
      queryParameters['offer_type_id'] = offerTypeId;
    }
    if (governorateId != null) {
      queryParameters['governorate_id'] = governorateId;
    }
    if (districtId != null) {
      queryParameters['district_id'] = districtId;
    }
    if (neighborhoodId != null) {
      queryParameters['neighborhood_id'] = neighborhoodId;
    }
    if (minPrice != null) {
      queryParameters['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      queryParameters['max_price'] = maxPrice;
    }

    final response = await apiConsumer.get(
      EndPoints.officeProperties,
      queryParameters: queryParameters,
    );

    print('Here is the response:$response');

    return OfficePropertiesResponseModel.fromJson(response);
  }

  @override
  Future<PropertyStatsModel> getPropertyStats() async {
    final response = await apiConsumer.get(EndPoints.officePropertiesStats);
    return PropertyStatsModel.fromJson(response['data']);
  }

  @override
  Future<String> deleteProperty(int propertyId) async {
    final response = await apiConsumer.delete(
      EndPoints.deleteOfficeProperty(propertyId),
    );
    return response['message'] ?? 'تم حذف العقار بنجاح';
  }

  @override
  Future<PropertyDetailsResponseModel> getPropertyDetails({
    required int propertyId,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.officePropertyDetails(propertyId),
    );

    print('Property Details Response: $response');

    return PropertyDetailsResponseModel.fromJson(response);
  }

  @override
  Future<PropertyDetailsResponseModel> updatePropertyStatus({
    required int propertyId,
    required String status,
  }) async {
    final response = await apiConsumer.patch(
      EndPoints.updateOfficePropertyStatus(propertyId),
      data: {'status': status},
    );

    print('Update Property Status Response: $response');

    return PropertyDetailsResponseModel.fromJson(response);
  }

  @override
  Future<UploadImagesResponseModel> uploadPropertyImages({
    required int propertyId,
    required List<String> imagePaths,
  }) async {
    // Create FormData with multiple images
    final formData = FormData();

    for (final imagePath in imagePaths) {
      final file = await MultipartFile.fromFile(
        imagePath,
        filename: imagePath.split('/').last,
      );
      formData.files.add(MapEntry('images[]', file));
    }

    final response = await apiConsumer.post(
      EndPoints.uploadPropertyImages(propertyId),
      data: formData,
      isFormData: true,
    );

    print('Upload Images Response: $response');

    return UploadImagesResponseModel.fromJson(response);
  }

  @override
  Future<String> setPrimaryImage({
    required int propertyId,
    required int imageId,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.setPrimaryImage(propertyId, imageId),
    );

    print('Set Primary Image Response: $response');

    return response['message'] ?? 'تم تعيين الصورة كرئيسية بنجاح';
  }

  @override
  Future<String> deletePropertyImage({
    required int propertyId,
    required int imageId,
  }) async {
    final response = await apiConsumer.delete(
      EndPoints.deletePropertyImage(propertyId, imageId),
    );

    print('Delete Property Image Response: $response');

    return response['message'] ?? 'تم حذف الصورة بنجاح';
  }

  @override
  Future<PropertyDetailsResponseModel> createProperty({
    required CreatePropertyModel property,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.createOfficeProperty,
      data: property.toJson(),
    );

    print('Create Property Response: $response');

    return PropertyDetailsResponseModel.fromJson(response);
  }

  @override
  Future<PropertyDetailsResponseModel> updateProperty({
    required int propertyId,
    required Map<String, dynamic> data,
  }) async {
    final response = await apiConsumer.put(
      EndPoints.updateOfficeProperty(propertyId),
      data: data,
    );

    print('Update Property Response: $response');

    return PropertyDetailsResponseModel.fromJson(response);
  }
}
