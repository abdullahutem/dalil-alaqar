import 'employee_stats_entity.dart';

class EmployeeStatsResponseEntity {
  final bool success;
  final String message;
  final EmployeeStatsEntity data;

  const EmployeeStatsResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
