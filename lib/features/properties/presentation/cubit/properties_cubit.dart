import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_local_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/property_details_local_data_source.dart';
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
    final PropertiesLocalDataSource localDataSource =
        PropertiesLocalDataSourceImpl(databaseHelper: DatabaseHelper.instance);
    final PropertyDetailsLocalDataSource propertyDetailsLocalDataSource =
        PropertyDetailsLocalDataSourceImpl(
          databaseHelper: DatabaseHelper.instance,
        );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final PropertiesRepositoryImpl repository = PropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      propertyDetailsLocalDataSource: propertyDetailsLocalDataSource,
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

  // Search parameters
  String? _search;
  int? _propertyTypeId;
  int? _offerTypeId;
  int? _governorateId;
  int? _districtId;
  int? _neighborhoodId;
  double? _minPrice;
  double? _maxPrice;

  Future<void> getProperties({
    bool refresh = false,
    String? search,
    int? propertyTypeId,
    int? offerTypeId,
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (isClosed) return;

    if (refresh) {
      _currentPage = 1;
      _allProperties = [];
      _meta = null;
      // Update search parameters
      _search = search;
      _propertyTypeId = propertyTypeId;
      _offerTypeId = offerTypeId;
      _governorateId = governorateId;
      _districtId = districtId;
      _neighborhoodId = neighborhoodId;
      _minPrice = minPrice;
      _maxPrice = maxPrice;
    }

    if (state is PropertiesLoading) return;

    if (!isClosed) {
      emit(PropertiesLoading());
    }

    final result = await getPropertiesUseCase(
      page: _currentPage,
      search: _search,
      propertyTypeId: _propertyTypeId,
      offerTypeId: _offerTypeId,
      governorateId: _governorateId,
      districtId: _districtId,
      neighborhoodId: _neighborhoodId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          emit(PropertiesError(message: failure.errMessage));
        }
      },
      (response) {
        if (!isClosed) {
          _allProperties = response.properties;
          _meta = response.meta;
          emit(PropertiesSuccess(propertiesResponse: response));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (_meta == null || _currentPage >= _meta!.lastPage) return;

    if (state is! PropertiesSuccess) return;

    final currentState = state as PropertiesSuccess;

    // Show loading indicator for pagination
    if (!isClosed) {
      emit(
        PropertiesSuccess(
          propertiesResponse: currentState.propertiesResponse,
          isLoadingMore: true,
        ),
      );
    }

    _currentPage++;

    final result = await getPropertiesUseCase(
      page: _currentPage,
      search: _search,
      propertyTypeId: _propertyTypeId,
      offerTypeId: _offerTypeId,
      governorateId: _governorateId,
      districtId: _districtId,
      neighborhoodId: _neighborhoodId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        _currentPage--; // Revert page increment on error
        if (!isClosed) {
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
        }
      },
      (response) {
        if (!isClosed) {
          _allProperties.addAll(response.properties);
          _meta = response.meta;

          final updatedResponse = PropertiesResponseEntity(
            properties: _allProperties,
            meta: _meta!,
          );

          emit(PropertiesSuccess(propertiesResponse: updatedResponse));
        }
      },
    );
  }

  void clearFilters() {
    _search = null;
    _propertyTypeId = null;
    _offerTypeId = null;
    _governorateId = null;
    _districtId = null;
    _neighborhoodId = null;
    _minPrice = null;
    _maxPrice = null;
    getProperties(refresh: true);
  }

  bool get hasMore => _meta != null && _currentPage < _meta!.lastPage;

  bool get hasActiveFilters =>
      _search != null ||
      _propertyTypeId != null ||
      _offerTypeId != null ||
      _governorateId != null ||
      _districtId != null ||
      _neighborhoodId != null ||
      _minPrice != null ||
      _maxPrice != null;
}
