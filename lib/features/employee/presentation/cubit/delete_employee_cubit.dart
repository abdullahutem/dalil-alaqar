import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/employee/data/datasources/employees_local_data_source.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/employees_remote_data_source.dart';
import '../../data/repositories/employees_repository_impl.dart';
import '../../domain/usecases/delete_employee_usecase.dart';
import 'delete_employee_state.dart';

class DeleteEmployeeCubit extends Cubit<DeleteEmployeeState> {
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  DeleteEmployeeCubit({required this.deleteEmployeeUseCase})
    : super(const DeleteEmployeeInitial());

  factory DeleteEmployeeCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = EmployeesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final localDataSource = EmployeesLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = EmployeesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );
    final useCase = DeleteEmployeeUseCase(repository);
    return DeleteEmployeeCubit(deleteEmployeeUseCase: useCase);
  }

  Future<void> deleteEmployee({required int employeeId}) async {
    emit(const DeleteEmployeeLoading());
    final result = await deleteEmployeeUseCase(employeeId: employeeId);
    result.fold(
      (failure) => emit(DeleteEmployeeError(message: failure.errMessage)),
      (response) => emit(DeleteEmployeeSuccess(message: response.message)),
    );
  }

  void reset() {
    emit(const DeleteEmployeeInitial());
  }
}
