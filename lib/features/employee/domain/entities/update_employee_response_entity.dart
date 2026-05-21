import 'employee_entity.dart';

class UpdateEmployeeResponseEntity {
  final bool success;
  final String message;
  final EmployeeEntity data;

  const UpdateEmployeeResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
