import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/add_employee_response_entity.dart';
import '../repositories/employees_repository.dart';

class AddEmployeeUseCase {
  final EmployeesRepository repository;

  AddEmployeeUseCase(this.repository);

  Future<Either<Failure, AddEmployeeResponseEntity>> call({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String whatsappNumber,
    required String address,
    required String role,
  }) async {
    return await repository.addEmployee(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      address: address,
      role: role,
    );
  }
}
