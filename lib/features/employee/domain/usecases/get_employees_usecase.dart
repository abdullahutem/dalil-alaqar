import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/employees_response_entity.dart';
import '../repositories/employees_repository.dart';

class GetEmployeesUseCase {
  final EmployeesRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Either<Failure, EmployeesResponseEntity>> call({
    required int page,
    required int perPage,
  }) {
    return repository.getEmployees(page: page, perPage: perPage);
  }
}
