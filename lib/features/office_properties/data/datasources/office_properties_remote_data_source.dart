import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/office_properties/data/models/property_details_response_model.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/office_properties_response_model.dart';
import '../models/property_stats_model.dart';

abstract class OfficePropertiesRemoteDataSource {
  Future<OfficePropertiesResponseModel> getOfficeProperties({
    required int page,
    required int perPage,
  });
  Future<PropertyDetailsResponseModel> getPropertyDetails({
    required int propertyId,
  });

  Future<PropertyStatsModel> getPropertyStats();

  Future<String> deleteProperty(int propertyId);
}

class OfficePropertiesRemoteDataSourceImpl
    implements OfficePropertiesRemoteDataSource {
  ApiConsumer apiConsumer;
  OfficePropertiesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficePropertiesResponseModel> getOfficeProperties({
    required int page,
    required int perPage,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.officeProperties,
      queryParameters: {'page': page, 'per_page': perPage},
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
      EndPoints.propertyDetails(propertyId),
    );
    return PropertyDetailsResponseModel.fromJson(response['data']);
  }
}
