import '../../domain/entities/employees_response_entity.dart';
import 'employee_model.dart';

class EmployeesResponseModel extends EmployeesResponseEntity {
  const EmployeesResponseModel({
    required super.employees,
    required super.currentPage,
    required super.lastPage,
    required super.perPage,
    required super.total,
  });

  factory EmployeesResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final employeesList = (data['data'] as List<dynamic>)
        .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return EmployeesResponseModel(
      employees: employeesList,
      currentPage: data['current_page'] as int,
      lastPage: data['last_page'] as int,
      perPage: data['per_page'] as int,
      total: data['total'] as int,
    );
  }
}
