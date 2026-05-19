import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../data/datasources/promotions_remote_data_source.dart';
import '../../data/repositories/promotions_repository_impl.dart';
import '../../domain/usecases/get_promotions_usecase.dart';
import '../../../../core/network/network_info.dart';
import 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final GetPromotionsUseCase getPromotionsUseCase;

  PromotionsCubit({required this.getPromotionsUseCase})
      : super(const PromotionsInitial());

  factory PromotionsCubit.create() {
    final dio = Dio();
    final networkInfo = NetworkInfoImpl(InternetConnectionChecker());
    final remoteDataSource = PromotionsRemoteDataSourceImpl(dio: dio);
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
      (failure) => emit(PromotionsError(message: failure.message)),
      (response) =>
          emit(PromotionsSuccess(promotions: response.data)),
    );
  }

  Future<void> refresh() => getPromotions();
}
