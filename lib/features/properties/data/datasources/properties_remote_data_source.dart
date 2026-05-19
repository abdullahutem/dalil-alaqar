import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/properties/data/models/properties_response_model.dart';
import 'package:dalil_alaqar/features/properties/data/models/property_details_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<PropertiesResponseModel> getProperties({
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

  Future<PropertyDetailsModel> getPropertyDetails({required int id});
}

class PropertiesRemoteDataSourceImpl implements PropertiesRemoteDataSource {
  final ApiConsumer apiConsumer;

  PropertiesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PropertiesResponseModel> getProperties({
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

    // Add optional parameters only if they are not null
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
      EndPoints.properties,
      queryParameters: queryParameters,
    );

    return PropertiesResponseModel.fromJson(response);
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetails({required int id}) async {
    final response = await apiConsumer.get(EndPoints.propertyDetails(id));

    return PropertyDetailsModel.fromJson(response['data']);
  }
}
