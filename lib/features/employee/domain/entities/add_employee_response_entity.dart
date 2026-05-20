import 'employee_entity.dart';

class AddEmployeeResponseEntity {
  final bool success;
  final String message;
  final EmployeeEntity data;

  const AddEmployeeResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
