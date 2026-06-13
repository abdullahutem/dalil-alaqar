import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/offer_types/data/datasources/offer_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/offer_types/data/repositories/offer_types_repository_impl.dart';
import 'package:dalil_alaqar/features/offer_types/domain/usecases/get_offer_types_usecase.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_state.dart';

class OfferTypesCubit extends Cubit<OfferTypesState> {
  final GetOfferTypesUseCase getOfferTypesUseCase;

  OfferTypesCubit({required this.getOfferTypesUseCase})
    : super(OfferTypesInitial());

  factory OfferTypesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final OfferTypesRemoteDataSource remoteDataSource =
        OfferTypesRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final OfferTypesRepositoryImpl repository = OfferTypesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetOfferTypesUseCase getOfferTypesUseCase = GetOfferTypesUseCase(
      repository: repository,
    );

    return OfferTypesCubit(getOfferTypesUseCase: getOfferTypesUseCase);
  }

  Future<void> getOfferTypes() async {
    if (isClosed) return;
    emit(OfferTypesLoading());

    final result = await getOfferTypesUseCase();

    result.fold(
      (failure) => emit(OfferTypesError(message: failure.errMessage)),
      (response) => emit(OfferTypesSuccess(response: response)),
    );
  }
}
