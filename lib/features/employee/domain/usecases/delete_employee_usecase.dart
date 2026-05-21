import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/delete_employee_response_entity.dart';
import '../repositories/employees_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeesRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<Either<Failure, DeleteEmployeeResponseEntity>> call({
    required int employeeId,
  }) async {
    return await repository.deleteEmployee(employeeId: employeeId);
  }
}
