import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/add_employee_response_entity.dart';
import '../../domain/entities/delete_employee_response_entity.dart';
import '../../domain/entities/employee_stats_response_entity.dart';
import '../../domain/entities/employees_response_entity.dart';
import '../../domain/entities/update_employee_response_entity.dart';
import '../../domain/repositories/employees_repository.dart';
import '../datasources/employees_remote_data_source.dart';
import '../models/add_employee_request_model.dart';
import '../models/update_employee_request_model.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmployeesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, EmployeesResponseEntity>> getEmployees({
    required int page,
    required int perPage,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getEmployees(
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, AddEmployeeResponseEntity>> addEmployee({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String whatsappNumber,
    required String address,
    required String role,
    required String userType,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final request = AddEmployeeRequestModel(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        whatsappNumber: whatsappNumber,
        address: address,
        role: role,
        userType: userType,
      );
      final result = await remoteDataSource.addEmployee(request: request);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, UpdateEmployeeResponseEntity>> updateEmployee({
    required int employeeId,
    required String name,
    required String email,
    required String phoneNumber,
    required String whatsappNumber,
    required String userType,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final request = UpdateEmployeeRequestModel(
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        whatsappNumber: whatsappNumber,
        userType: userType,
      );
      final result = await remoteDataSource.updateEmployee(
        employeeId: employeeId,
        request: request,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, DeleteEmployeeResponseEntity>> deleteEmployee({
    required int employeeId,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.deleteEmployee(
        employeeId: employeeId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, EmployeeStatsResponseEntity>>
  getEmployeeStats() async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getEmployeeStats();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
