import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/employees_remote_data_source.dart';
import '../../data/repositories/employees_repository_impl.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import 'update_employee_state.dart';

class UpdateEmployeeCubit extends Cubit<UpdateEmployeeState> {
  final UpdateEmployeeUseCase updateEmployeeUseCase;

  UpdateEmployeeCubit({required this.updateEmployeeUseCase})
    : super(const UpdateEmployeeInitial());

  factory UpdateEmployeeCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = EmployeesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = EmployeesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = UpdateEmployeeUseCase(repository);
    return UpdateEmployeeCubit(updateEmployeeUseCase: useCase);
  }

  Future<void> updateEmployee({
    required int employeeId,
    required String name,
    required String email,
    required String phoneNumber,
    required String whatsappNumber,
    required String userType,
  }) async {
    emit(const UpdateEmployeeLoading());
    final result = await updateEmployeeUseCase(
      employeeId: employeeId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      userType: userType,
    );
    result.fold(
      (failure) => emit(UpdateEmployeeError(message: failure.errMessage)),
      (response) => emit(
        UpdateEmployeeSuccess(
          employee: response.data,
          message: response.message,
        ),
      ),
    );
  }

  void reset() {
    emit(const UpdateEmployeeInitial());
  }
}
