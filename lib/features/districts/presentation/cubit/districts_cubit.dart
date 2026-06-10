import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_local_data_source.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_remote_data_source.dart';
import 'package:dalil_alaqar/features/districts/data/repositories/districts_repository_impl.dart';
import 'package:dalil_alaqar/features/districts/domain/usecases/get_districts_by_governorate_usecase.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_state.dart';

class DistrictsCubit extends Cubit<DistrictsState> {
  final GetDistrictsByGovernorateUseCase getDistrictsByGovernorateUseCase;

  DistrictsCubit({required this.getDistrictsByGovernorateUseCase})
    : super(DistrictsInitial());

  factory DistrictsCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final DistrictsRemoteDataSource remoteDataSource =
        DistrictsRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final DistrictsLocalDataSource localDataSource =
        DistrictsLocalDataSourceImpl(databaseHelper: DatabaseHelper.instance);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final DistrictsRepositoryImpl repository = DistrictsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetDistrictsByGovernorateUseCase getDistrictsByGovernorateUseCase =
        GetDistrictsByGovernorateUseCase(repository: repository);

    return DistrictsCubit(
      getDistrictsByGovernorateUseCase: getDistrictsByGovernorateUseCase,
    );
  }

  Future<void> getDistrictsByGovernorate(int governorateId) async {
    emit(DistrictsLoading());

    final result = await getDistrictsByGovernorateUseCase(governorateId);

    result.fold(
      (failure) => emit(DistrictsError(message: failure.errMessage)),
      (response) => emit(
        DistrictsSuccess(response: response, governorateId: governorateId),
      ),
    );
  }

  void clearDistricts() {
    emit(DistrictsInitial());
  }
}
