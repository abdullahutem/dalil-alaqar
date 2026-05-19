import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/offices/data/datasources/offices_remote_data_source.dart';
import 'package:dalil_alaqar/features/offices/data/repositories/offices_repository_impl.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:dalil_alaqar/features/offices/domain/usecases/get_offices_usecase.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dio/dio.dart';
import 'offices_state.dart';

class OfficesCubit extends Cubit<OfficesState> {
  final GetOfficesUseCase getOfficesUseCase;
  static const int _perPage = 20;

  OfficesCubit({required this.getOfficesUseCase})
    : super(const OfficesInitial());

  /// Factory constructor for dependency injection
  factory OfficesCubit.create() {
    final dio = Dio();
    final ApiConsumer apiConsumer = DioConsumer(dio: dio);

    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final remoteDataSource = OfficesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final repository = OfficesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = GetOfficesUseCase(repository);
    return OfficesCubit(getOfficesUseCase: useCase);
  }

  Future<void> getOffices() async {
    emit(const OfficesLoading());
    final result = await getOfficesUseCase(page: 1, perPage: _perPage);
    result.fold(
      (failure) => emit(OfficesError(message: failure.errMessage)),
      (response) => emit(
        OfficesSuccess(
          offices: response.data,
          hasReachedMax: response.meta.currentPage >= response.meta.lastPage,
          currentPage: response.meta.currentPage,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! OfficesSuccess) return;
    if (currentState.hasReachedMax) return;

    final nextPage = currentState.currentPage + 1;
    final result = await getOfficesUseCase(page: nextPage, perPage: _perPage);

    result.fold(
      (failure) => emit(
        OfficesLoadMoreError(
          message: failure.errMessage,
          offices: currentState.offices,
          currentPage: currentState.currentPage,
        ),
      ),
      (response) {
        final updatedOffices = List<OfficeEntity>.from(currentState.offices)
          ..addAll(response.data);
        emit(
          OfficesSuccess(
            offices: updatedOffices,
            hasReachedMax: response.meta.currentPage >= response.meta.lastPage,
            currentPage: response.meta.currentPage,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    await getOffices();
  }
}
