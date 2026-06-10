import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../../../core/databases/local/database_helper.dart';
import '../../data/datasources/plans_local_data_source.dart';
import '../../data/datasources/plans_remote_data_source.dart';
import '../../data/repositories/plans_repository_impl.dart';
import '../../domain/usecases/get_plans_usecase.dart';
import 'plans_state.dart';

class PlansCubit extends Cubit<PlansState> {
  final GetPlansUseCase getPlansUseCase;

  PlansCubit({required this.getPlansUseCase}) : super(PlansInitial());

  factory PlansCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final PlansRemoteDataSource remoteDataSource = PlansRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final PlansLocalDataSource localDataSource = PlansLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final PlansRepositoryImpl repository = PlansRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetPlansUseCase getPlansUseCase = GetPlansUseCase(
      repository: repository,
    );

    return PlansCubit(getPlansUseCase: getPlansUseCase);
  }

  Future<void> getPlans() async {
    emit(PlansLoading());

    final result = await getPlansUseCase.call();

    result.fold(
      (failure) => emit(PlansError(message: failure.errMessage)),
      (plans) => emit(PlansLoaded(plans: plans)),
    );
  }
}
