import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../models/add_employee_request_model.dart';
import '../models/add_employee_response_model.dart';
import '../models/delete_employee_response_model.dart';
import '../models/employee_stats_response_model.dart';
import '../models/employees_response_model.dart';
import '../models/update_employee_request_model.dart';
import '../models/update_employee_response_model.dart';

abstract class EmployeesRemoteDataSource {
  Future<EmployeesResponseModel> getEmployees({
    required int page,
    required int perPage,
  });

  Future<AddEmployeeResponseModel> addEmployee({
    required AddEmployeeRequestModel request,
  });

  Future<UpdateEmployeeResponseModel> updateEmployee({
    required int employeeId,
    required UpdateEmployeeRequestModel request,
  });

  Future<DeleteEmployeeResponseModel> deleteEmployee({required int employeeId});

  Future<EmployeeStatsResponseModel> getEmployeeStats();
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

  @override
  Future<AddEmployeeResponseModel> addEmployee({
    required AddEmployeeRequestModel request,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.employees,
      queryParameters: request.toJson(),
    );
    return AddEmployeeResponseModel.fromJson(response);
  }

  @override
  Future<UpdateEmployeeResponseModel> updateEmployee({
    required int employeeId,
    required UpdateEmployeeRequestModel request,
  }) async {
    final response = await apiConsumer.put(
      '${EndPoints.employees}/$employeeId',
      queryParameters: request.toJson(),
    );
    return UpdateEmployeeResponseModel.fromJson(response);
  }

  @override
  Future<DeleteEmployeeResponseModel> deleteEmployee({
    required int employeeId,
  }) async {
    final response = await apiConsumer.delete(
      '${EndPoints.employees}/$employeeId',
    );
    return DeleteEmployeeResponseModel.fromJson(response);
  }

  @override
  Future<EmployeeStatsResponseModel> getEmployeeStats() async {
    final response = await apiConsumer.get('${EndPoints.employees}/stats');
    return EmployeeStatsResponseModel.fromJson(response);
  }
}
