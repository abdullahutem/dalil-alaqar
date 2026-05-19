import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/districts/data/models/districts_response_model.dart';

abstract class DistrictsRemoteDataSource {
  Future<DistrictsResponseModel> getDistrictsByGovernorate(int governorateId);
}

class DistrictsRemoteDataSourceImpl implements DistrictsRemoteDataSource {
  final ApiConsumer apiConsumer;

  DistrictsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<DistrictsResponseModel> getDistrictsByGovernorate(
    int governorateId,
  ) async {
    final response = await apiConsumer.get(
      EndPoints.districtsByGovernorate(governorateId),
    );
    return DistrictsResponseModel.fromJson(response);
  }
}
