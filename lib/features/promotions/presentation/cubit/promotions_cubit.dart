import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/promotions/data/datasources/promotions_remote_data_source.dart';
import 'package:dalil_alaqar/features/promotions/data/repositories/promotions_repository_impl.dart';
import 'package:dalil_alaqar/features/promotions/domain/usecases/get_promotions_usecase.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final GetPromotionsUseCase getPromotionsUseCase;

  PromotionsCubit({required this.getPromotionsUseCase})
    : super(const PromotionsInitial());

  factory PromotionsCubit.create() {
    final dio = Dio();
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final ApiConsumer apiConsumer = DioConsumer(dio: dio);

    final remoteDataSource = PromotionsRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final repository = PromotionsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    return PromotionsCubit(
      getPromotionsUseCase: GetPromotionsUseCase(repository),
    );
  }

  Future<void> getPromotions() async {
    emit(const PromotionsLoading());
    final result = await getPromotionsUseCase();
    result.fold(
      (failure) => emit(PromotionsError(message: failure.errMessage)),
      (response) => emit(PromotionsSuccess(promotions: response.data)),
    );
  }

  Future<void> refresh() => getPromotions();
}
