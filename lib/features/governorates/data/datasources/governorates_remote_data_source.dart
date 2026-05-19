import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/governorates/data/models/governorates_response_model.dart';

abstract class GovernoratesRemoteDataSource {
  Future<GovernoratesResponseModel> getGovernorates();
}

class GovernoratesRemoteDataSourceImpl implements GovernoratesRemoteDataSource {
  final ApiConsumer apiConsumer;

  GovernoratesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<GovernoratesResponseModel> getGovernorates() async {
    final response = await apiConsumer.get(EndPoints.governorates);
    return GovernoratesResponseModel.fromJson(response);
  }
}
