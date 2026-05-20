import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/employees_response_entity.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, EmployeesResponseEntity>> getEmployees({
    required int page,
    required int perPage,
  });
}
