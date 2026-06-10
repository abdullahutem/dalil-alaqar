import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../domain/entities/add_employee_response_entity.dart';
import '../../domain/entities/delete_employee_response_entity.dart';
import '../../domain/entities/employee_stats_response_entity.dart';
import '../../domain/entities/employees_response_entity.dart';
import '../../domain/entities/update_employee_response_entity.dart';
import '../../domain/repositories/employees_repository.dart';
import '../datasources/employees_local_data_source.dart';
import '../datasources/employees_remote_data_source.dart';
import '../models/add_employee_request_model.dart';
import '../models/employee_model.dart';
import '../models/employees_response_model.dart';
import '../models/update_employee_request_model.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDataSource remoteDataSource;
  final EmployeesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  EmployeesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, EmployeesResponseEntity>> getEmployees({
    required int page,
    required int perPage,
  }) async {
    // فقط نخزن الصفحة الأولى في الكاش (smart caching)
    final isFirstPage = page == 1;

    if (isFirstPage) {
      // محاولة تحميل من الكاش السريع
      final cachedData = _cacheManager.getCachedEmployeesData();

      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = json.decode(cachedData);
          final employeesResponse = EmployeesResponseModel.fromJson(jsonData);

          // تحديث الكاش في الخلفية
          _updateCacheInBackground(page: page, perPage: perPage);

          return Right(employeesResponse);
        } catch (e) {
          print('Error parsing cached employees data: $e');
        }
      }
    }

    // التحميل من API أو الكاش المحلي
    if (await networkInfo.isConnected ?? false) {
      try {
        final EmployeesResponseModel result = await remoteDataSource
            .getEmployees(page: page, perPage: perPage);

        // حفظ الصفحة الأولى فقط في الكاش
        if (isFirstPage) {
          final employees = result.employees
              .whereType<EmployeeModel>()
              .toList();
          await localDataSource.cacheEmployees(employees);

          final jsonData = result.toJson();
          await _cacheManager.cacheEmployeesData(json.encode(jsonData));
        }

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        if (isFirstPage) {
          return await _loadFromCache();
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } on DioException catch (e) {
        print('DioException: $e');
        if (isFirstPage) {
          return await _loadFromCache();
        }
        return Left(ServerFailure(errMessage: e.toString()));
      } catch (e, stackTrace) {
        print('Error fetching employees: $e');
        print('Stack trace: $stackTrace');
        if (isFirstPage) {
          return await _loadFromCache();
        }
        return Left(ServerFailure(errMessage: e.toString()));
      }
    } else {
      if (isFirstPage) {
        return await _loadFromCache();
      }
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  Future<void> _updateCacheInBackground({
    required int page,
    required int perPage,
  }) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final EmployeesResponseModel result = await remoteDataSource
            .getEmployees(page: page, perPage: perPage);

        final employees = result.employees.whereType<EmployeeModel>().toList();
        await localDataSource.cacheEmployees(employees);

        final jsonData = result.toJson();
        await _cacheManager.cacheEmployeesData(json.encode(jsonData));
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, EmployeesResponseEntity>> _loadFromCache() async {
    try {
      final cachedEmployees = await localDataSource.getCachedEmployees();

      if (cachedEmployees.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا يوجد موظفون محفوظون. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // إنشاء استجابة مع البيانات المخزنة
      // نستخدم قيم افتراضية للصفحات لأننا نخزن الصفحة الأولى فقط
      final response = EmployeesResponseModel(
        employees: cachedEmployees,
        currentPage: 1,
        lastPage: 1,
        perPage: cachedEmployees.length,
        total: cachedEmployees.length,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
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

      // إلغاء الكاش بعد إضافة موظف جديد
      await _clearCache();

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

      // إلغاء الكاش بعد تحديث موظف
      await _clearCache();

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

      // إلغاء الكاش بعد حذف موظف
      await _clearCache();

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

  /// إلغاء الكاش عند إضافة/تحديث/حذف موظف
  Future<void> _clearCache() async {
    try {
      await localDataSource.clearEmployees();
      await _cacheManager.clearCache(CacheManager.employeesCacheKey);
    } catch (e) {
      print('Error clearing employees cache: $e');
    }
  }
}
