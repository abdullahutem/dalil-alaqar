import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/governorates/data/datasources/governorates_remote_data_source.dart';
import 'package:dalil_alaqar/features/governorates/data/repositories/governorates_repository_impl.dart';
import 'package:dalil_alaqar/features/governorates/domain/usecases/get_governorates_usecase.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_state.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  final GetGovernoratesUseCase getGovernoratesUseCase;

  GovernoratesCubit({required this.getGovernoratesUseCase})
    : super(GovernoratesInitial());

  factory GovernoratesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final GovernoratesRemoteDataSource remoteDataSource =
        GovernoratesRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final GovernoratesRepositoryImpl repository = GovernoratesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetGovernoratesUseCase getGovernoratesUseCase =
        GetGovernoratesUseCase(repository: repository);

    return GovernoratesCubit(getGovernoratesUseCase: getGovernoratesUseCase);
  }

  Future<void> getGovernorates() async {
    emit(GovernoratesLoading());

    final result = await getGovernoratesUseCase();

    result.fold(
      (failure) => emit(GovernoratesError(message: failure.errMessage)),
      (response) => emit(GovernoratesSuccess(response: response)),
    );
  }
}
