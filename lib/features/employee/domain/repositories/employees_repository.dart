import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/add_employee_response_entity.dart';
import '../entities/delete_employee_response_entity.dart';
import '../entities/employees_response_entity.dart';
import '../entities/update_employee_response_entity.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, EmployeesResponseEntity>> getEmployees({
    required int page,
    required int perPage,
  });

  Future<Either<Failure, AddEmployeeResponseEntity>> addEmployee({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String whatsappNumber,
    required String address,
    required String role,
    required String userType,
  });

  Future<Either<Failure, UpdateEmployeeResponseEntity>> updateEmployee({
    required int employeeId,
    required String name,
    required String email,
    required String phoneNumber,
    required String whatsappNumber,
    required String userType,
  });

  Future<Either<Failure, DeleteEmployeeResponseEntity>> deleteEmployee({
    required int employeeId,
  });
}
