import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/properties/data/models/properties_response_model.dart';

abstract class PropertiesRemoteDataSource {
  Future<PropertiesResponseModel> getProperties({
    int page = 1,
    int perPage = 20,
  });
}

class PropertiesRemoteDataSourceImpl implements PropertiesRemoteDataSource {
  final ApiConsumer apiConsumer;

  PropertiesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PropertiesResponseModel> getProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.properties,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return PropertiesResponseModel.fromJson(response);
  }
}
