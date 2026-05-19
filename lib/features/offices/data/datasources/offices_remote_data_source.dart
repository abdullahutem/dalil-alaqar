import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/offices/data/models/offices_response_model.dart';
import '../../../../../../core/databases/api/end_points.dart';

abstract class OfficesRemoteDataSource {
  Future<OfficesResponseModel> getOffices({
    required int page,
    required int perPage,
  });
}

class OfficesRemoteDataSourceImpl implements OfficesRemoteDataSource {
  final ApiConsumer apiConsumer;

  OfficesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OfficesResponseModel> getOffices({
    required int page,
    required int perPage,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.offices,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return OfficesResponseModel.fromJson(response);
  }
}
