import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/properties/data/models/properties_response_model.dart';
import 'package:dalil_alaqar/features/properties/data/models/property_details_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<PropertiesResponseModel> getProperties({
    required int page,
    required int perPage,
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
  }) async {
    final response = await apiConsumer.get(
      EndPoints.properties,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return PropertiesResponseModel.fromJson(response);
  }

  @override
  Future<PropertyDetailsModel> getPropertyDetails({required int id}) async {
    final response = await apiConsumer.get(EndPoints.propertyDetails(id));

    return PropertyDetailsModel.fromJson(response['data']);
  }
}
