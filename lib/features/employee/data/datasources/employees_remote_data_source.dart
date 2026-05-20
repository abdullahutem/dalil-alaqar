import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/employees_response_model.dart';

abstract class EmployeesRemoteDataSource {
  Future<EmployeesResponseModel> getEmployees({
    required int page,
    required int perPage,
  });
}

class EmployeesRemoteDataSourceImpl implements EmployeesRemoteDataSource {
  final ApiConsumer apiConsumer;
  EmployeesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<EmployeesResponseModel> getEmployees({
    required int page,
    required int perPage,
  }) async {
    final response = await apiConsumer.get(
      EndPoints.employees,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return EmployeesResponseModel.fromJson(response);
  }
}
