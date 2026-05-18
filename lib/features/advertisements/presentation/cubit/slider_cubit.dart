import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/advertisements/data/datasources/slider_local_data_source.dart';
import 'package:dalil_alaqar/features/advertisements/data/datasources/slider_remote_data_source.dart';
import 'package:dalil_alaqar/features/advertisements/data/repositories/slider_repository_impl.dart';
import 'package:dalil_alaqar/features/advertisements/domain/usecases/get_slides_usecase.dart';
import 'package:dalil_alaqar/features/advertisements/presentation/cubit/slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  final GetSlidesUseCase getSlidesUseCase;

  SliderCubit({required this.getSlidesUseCase}) : super(SliderInitial());

  factory SliderCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final SliderRemoteDataSource remoteDataSource = SliderRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final SliderLocalDataSource localDataSource = SliderLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final SliderRepositoryImpl repository = SliderRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetSlidesUseCase getSlidesUseCase = GetSlidesUseCase(repository);

    return SliderCubit(getSlidesUseCase: getSlidesUseCase);
  }

  Future<void> getSlides() async {
    emit(SliderLoading());

    final result = await getSlidesUseCase();

    result.fold(
      (failure) => emit(SliderError(failure.errMessage)),
      (sliderResponse) => emit(SliderSuccess(sliderResponse)),
    );
  }
}
