import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/employee/data/datasources/employees_local_data_source.dart';
import 'package:dalil_alaqar/features/employee/data/datasources/employees_remote_data_source.dart';
import 'package:dalil_alaqar/features/employee/data/repositories/employees_repository_impl.dart';
import 'package:dalil_alaqar/features/employee/domain/usecases/get_employee_stats_usecase.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_stats_state.dart';

class EmployeeStatsCubit extends Cubit<EmployeeStatsState> {
  final GetEmployeeStatsUseCase getEmployeeStatsUseCase;

  EmployeeStatsCubit({required this.getEmployeeStatsUseCase})
    : super(EmployeeStatsInitial());

  static EmployeeStatsCubit create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final remoteDataSource = EmployeesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final localDataSource = EmployeesLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );

    final repository = EmployeesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
      localDataSource: localDataSource,
    );
    final useCase = GetEmployeeStatsUseCase(repository: repository);
    return EmployeeStatsCubit(getEmployeeStatsUseCase: useCase);
  }

  Future<void> getStats() async {
    if (isClosed) return; // Don't emit if cubit is already closed

    emit(EmployeeStatsLoading());
    final result = await getEmployeeStatsUseCase();

    if (isClosed) return; // Check again after async operation

    result.fold(
      (failure) => emit(EmployeeStatsError(message: failure.errMessage)),
      (response) => emit(EmployeeStatsSuccess(stats: response.data)),
    );
  }
}
