import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/models/neighborhoods_response_model.dart';

abstract class NeighborhoodsRemoteDataSource {
  Future<NeighborhoodsResponseModel> getNeighborhoodsByDistrict(int districtId);
}

class NeighborhoodsRemoteDataSourceImpl
    implements NeighborhoodsRemoteDataSource {
  final ApiConsumer apiConsumer;

  NeighborhoodsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<NeighborhoodsResponseModel> getNeighborhoodsByDistrict(
    int districtId,
  ) async {
    final response = await apiConsumer.get(
      EndPoints.neighborhoodsByDistrict(districtId),
    );
    return NeighborhoodsResponseModel.fromJson(response);
  }
}
