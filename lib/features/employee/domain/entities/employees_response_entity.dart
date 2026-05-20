import 'employee_entity.dart';

class EmployeesResponseEntity {
  final List<EmployeeEntity> employees;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const EmployeesResponseEntity({
    required this.employees,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });
}
