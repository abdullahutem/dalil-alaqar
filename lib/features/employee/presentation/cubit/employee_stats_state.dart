import '../../domain/entities/employee_stats_entity.dart';

abstract class EmployeeStatsState {}

class EmployeeStatsInitial extends EmployeeStatsState {}

class EmployeeStatsLoading extends EmployeeStatsState {}

class EmployeeStatsSuccess extends EmployeeStatsState {
  final EmployeeStatsEntity stats;

  EmployeeStatsSuccess({required this.stats});
}

class EmployeeStatsError extends EmployeeStatsState {
  final String message;

  EmployeeStatsError({required this.message});
}
