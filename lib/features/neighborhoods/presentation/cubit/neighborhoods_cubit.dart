import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/datasources/neighborhoods_remote_data_source.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/repositories/neighborhoods_repository_impl.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/usecases/get_neighborhoods_by_district_usecase.dart';
import 'package:dalil_alaqar/features/neighborhoods/presentation/cubit/neighborhoods_state.dart';

class NeighborhoodsCubit extends Cubit<NeighborhoodsState> {
  final GetNeighborhoodsByDistrictUseCase getNeighborhoodsByDistrictUseCase;

  NeighborhoodsCubit({required this.getNeighborhoodsByDistrictUseCase})
    : super(NeighborhoodsInitial());

  factory NeighborhoodsCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final NeighborhoodsRemoteDataSource remoteDataSource =
        NeighborhoodsRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final NeighborhoodsRepositoryImpl repository = NeighborhoodsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetNeighborhoodsByDistrictUseCase getNeighborhoodsByDistrictUseCase =
        GetNeighborhoodsByDistrictUseCase(repository: repository);

    return NeighborhoodsCubit(
      getNeighborhoodsByDistrictUseCase: getNeighborhoodsByDistrictUseCase,
    );
  }

  Future<void> getNeighborhoodsByDistrict(int districtId) async {
    emit(NeighborhoodsLoading());

    final result = await getNeighborhoodsByDistrictUseCase(districtId);

    result.fold(
      (failure) => emit(NeighborhoodsError(message: failure.errMessage)),
      (response) => emit(
        NeighborhoodsSuccess(response: response, districtId: districtId),
      ),
    );
  }

  void clearNeighborhoods() {
    emit(NeighborhoodsInitial());
  }
}
