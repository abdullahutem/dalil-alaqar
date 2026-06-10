import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/employees_local_data_source.dart';
import '../../data/datasources/employees_remote_data_source.dart';
import '../../data/repositories/employees_repository_impl.dart';
import '../../domain/usecases/get_employees_usecase.dart';
import 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  final GetEmployeesUseCase getEmployeesUseCase;

  static const int _perPage = 15;

  EmployeesCubit({required this.getEmployeesUseCase})
    : super(const EmployeesInitial());

  factory EmployeesCubit.create() {
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
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final useCase = GetEmployeesUseCase(repository);
    return EmployeesCubit(getEmployeesUseCase: useCase);
  }

  Future<void> getEmployees() async {
    emit(const EmployeesLoading());
    final result = await getEmployeesUseCase(page: 1, perPage: _perPage);
    result.fold(
      (failure) => emit(EmployeesError(message: failure.errMessage)),
      (response) => emit(
        EmployeesSuccess(
          employees: response.employees,
          currentPage: response.currentPage,
          lastPage: response.lastPage,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! EmployeesSuccess) return;
    if (currentState.currentPage >= currentState.lastPage) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getEmployeesUseCase(page: nextPage, perPage: _perPage);

    result.fold(
      (failure) => emit(
        EmployeesLoadMoreError(
          message: failure.errMessage,
          employees: currentState.employees,
          currentPage: currentState.currentPage,
          lastPage: currentState.lastPage,
        ),
      ),
      (response) => emit(
        EmployeesSuccess(
          employees: [...currentState.employees, ...response.employees],
          currentPage: response.currentPage,
          lastPage: response.lastPage,
        ),
      ),
    );
  }

  Future<void> refresh() => getEmployees();
}
