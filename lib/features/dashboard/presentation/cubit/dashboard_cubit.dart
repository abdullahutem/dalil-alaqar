import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dalil_alaqar/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:dalil_alaqar/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:dalil_alaqar/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:dalil_alaqar/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardStatsUseCase getDashboardStatsUseCase;

  DashboardCubit({required this.getDashboardStatsUseCase})
    : super(DashboardInitial());

  factory DashboardCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final DashboardRemoteDataSource remoteDataSource =
        DashboardRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final DashboardLocalDataSource localDataSource =
        DashboardLocalDataSourceImpl(databaseHelper: DatabaseHelper.instance);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final DashboardRepositoryImpl repository = DashboardRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetDashboardStatsUseCase getDashboardStatsUseCase =
        GetDashboardStatsUseCase(repository: repository);

    return DashboardCubit(getDashboardStatsUseCase: getDashboardStatsUseCase);
  }

  Future<void> getDashboardStats() async {
    emit(DashboardLoading());

    final result = await getDashboardStatsUseCase();

    result.fold(
      (failure) {
        emit(DashboardError(message: failure.errMessage));
      },
      (stats) {
        emit(DashboardSuccess(stats: stats));
      },
    );
  }

  Future<void> refresh() async {
    await getDashboardStats();
  }
}
