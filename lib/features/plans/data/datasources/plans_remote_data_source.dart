import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/plan_model.dart';

abstract class PlansRemoteDataSource {
  Future<List<PlanModel>> getPlans();
  Future<PlanModel> getPlanDetails(int planId);
}

class PlansRemoteDataSourceImpl implements PlansRemoteDataSource {
  final ApiConsumer apiConsumer;

  PlansRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<PlanModel>> getPlans() async {
    final response = await apiConsumer.get(EndPoints.plans);

    if (response['success'] == true && response['data'] != null) {
      final List<dynamic> data = response['data'] as List<dynamic>;
      return data
          .map((json) => PlanModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }

  @override
  Future<PlanModel> getPlanDetails(int planId) async {
    final response = await apiConsumer.get(EndPoints.planDetails(planId));

    if (response['success'] == true && response['data'] != null) {
      return PlanModel.fromJson(response['data'] as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load plan details');
    }
  }
}
