import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/promotions/data/models/promotions_response_model.dart';
import '../../../../../../core/databases/api/end_points.dart';

abstract class PromotionsRemoteDataSource {
  Future<PromotionsResponseModel> getPromotions();
}

class PromotionsRemoteDataSourceImpl implements PromotionsRemoteDataSource {
  final ApiConsumer apiConsumer;

  PromotionsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<PromotionsResponseModel> getPromotions() async {
    final response = await apiConsumer.get(EndPoints.offices);

    return PromotionsResponseModel.fromJson(response);
  }
}
