import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/repositories/properties_repository_impl.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/usecases/get_properties_usecase.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_state.dart';

class PropertiesCubit extends Cubit<PropertiesState> {
  final GetPropertiesUseCase getPropertiesUseCase;

  PropertiesCubit({required this.getPropertiesUseCase})
    : super(PropertiesInitial());

  factory PropertiesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final PropertiesRemoteDataSource remoteDataSource =
        PropertiesRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final PropertiesRepositoryImpl repository = PropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetPropertiesUseCase getPropertiesUseCase = GetPropertiesUseCase(
      repository: repository,
    );

    return PropertiesCubit(getPropertiesUseCase: getPropertiesUseCase);
  }

  int _currentPage = 1;
  List<PropertyEntity> _allProperties = [];
  PaginationMeta? _meta;

  Future<void> getProperties({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allProperties = [];
      _meta = null;
    }

    if (state is PropertiesLoading) return;

    emit(PropertiesLoading());

    final result = await getPropertiesUseCase(page: _currentPage);

    result.fold(
      (failure) {
        emit(PropertiesError(message: failure.errMessage));
      },
      (response) {
        _allProperties = response.properties;
        _meta = response.meta;
        emit(PropertiesSuccess(propertiesResponse: response));
      },
    );
  }

  Future<void> loadMore() async {
    if (_meta == null || _currentPage >= _meta!.lastPage) return;

    if (state is! PropertiesSuccess) return;

    final currentState = state as PropertiesSuccess;

    // Show loading indicator for pagination
    emit(
      PropertiesSuccess(
        propertiesResponse: currentState.propertiesResponse,
        isLoadingMore: true,
      ),
    );

    _currentPage++;

    final result = await getPropertiesUseCase(page: _currentPage);

    result.fold(
      (failure) {
        _currentPage--; // Revert page increment on error
        emit(
          PropertiesLoadMoreError(
            propertiesResponse: currentState.propertiesResponse,
            message: failure.errMessage,
          ),
        );
        // Restore previous state after showing error
        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            emit(
              PropertiesSuccess(
                propertiesResponse: currentState.propertiesResponse,
              ),
            );
          }
        });
      },
      (response) {
        _allProperties.addAll(response.properties);
        _meta = response.meta;

        final updatedResponse = PropertiesResponseEntity(
          properties: _allProperties,
          meta: _meta!,
        );

        emit(PropertiesSuccess(propertiesResponse: updatedResponse));
      },
    );
  }

  bool get hasMore => _meta != null && _currentPage < _meta!.lastPage;
}
