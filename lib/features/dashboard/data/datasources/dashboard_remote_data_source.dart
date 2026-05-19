import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import 'package:dalil_alaqar/features/dashboard/data/models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final ApiConsumer apiConsumer;

  DashboardRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<DashboardStatsModel> getDashboardStats() async {
    final response = await apiConsumer.get(EndPoints.dashboard);
    return DashboardStatsModel.fromJson(response['data']);
  }
}
