import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/employees_remote_data_source.dart';
import '../../data/repositories/employees_repository_impl.dart';
import '../../domain/usecases/add_employee_usecase.dart';
import 'add_employee_state.dart';

class AddEmployeeCubit extends Cubit<AddEmployeeState> {
  final AddEmployeeUseCase addEmployeeUseCase;

  AddEmployeeCubit({required this.addEmployeeUseCase})
    : super(const AddEmployeeInitial());

  factory AddEmployeeCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = EmployeesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = EmployeesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = AddEmployeeUseCase(repository);
    return AddEmployeeCubit(addEmployeeUseCase: useCase);
  }

  Future<void> addEmployee({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String whatsappNumber,
    required String address,
    required String role,
  }) async {
    emit(const AddEmployeeLoading());
    final result = await addEmployeeUseCase(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      address: address,
      role: role,
    );
    result.fold(
      (failure) => emit(AddEmployeeError(message: failure.errMessage)),
      (response) => emit(
        AddEmployeeSuccess(employee: response.data, message: response.message),
      ),
    );
  }

  void reset() {
    emit(const AddEmployeeInitial());
  }
}
