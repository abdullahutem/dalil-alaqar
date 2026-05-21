import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/update_employee_response_entity.dart';
import '../repositories/employees_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeesRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<Either<Failure, UpdateEmployeeResponseEntity>> call({
    required int employeeId,
    required String name,
    required String email,
    required String phoneNumber,
    required String whatsappNumber,
    required String userType,
  }) async {
    return await repository.updateEmployee(
      employeeId: employeeId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      userType: userType,
    );
  }
}
