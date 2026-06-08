import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import '../../data/datasources/currencies_remote_data_source.dart';
import '../../data/repositories/currencies_repository_impl.dart';
import '../../domain/usecases/get_currencies_usecase.dart';
import 'currencies_state.dart';

class CurrenciesCubit extends Cubit<CurrenciesState> {
  final GetCurrenciesUseCase getCurrenciesUseCase;

  CurrenciesCubit({required this.getCurrenciesUseCase})
    : super(CurrenciesInitial());

  factory CurrenciesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final CurrenciesRemoteDataSource remoteDataSource =
        CurrenciesRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final CurrenciesRepositoryImpl repository = CurrenciesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetCurrenciesUseCase getCurrenciesUseCase = GetCurrenciesUseCase(
      repository: repository,
    );

    return CurrenciesCubit(getCurrenciesUseCase: getCurrenciesUseCase);
  }

  Future<void> getCurrencies() async {
    emit(CurrenciesLoading());

    final result = await getCurrenciesUseCase();

    result.fold(
      (failure) => emit(CurrenciesError(message: failure.errMessage)),
      (response) => emit(CurrenciesSuccess(response: response)),
    );
  }
}
