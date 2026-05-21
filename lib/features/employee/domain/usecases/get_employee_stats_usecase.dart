import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/employee_stats_response_entity.dart';
import '../repositories/employees_repository.dart';

class GetEmployeeStatsUseCase {
  final EmployeesRepository repository;

  GetEmployeeStatsUseCase({required this.repository});

  Future<Either<Failure, EmployeeStatsResponseEntity>> call() async {
    return await repository.getEmployeeStats();
  }
}
