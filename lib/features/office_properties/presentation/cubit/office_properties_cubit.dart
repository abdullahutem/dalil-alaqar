import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/office_properties/domain/usecases/get_property_details_usecase.dart';
import 'package:dalil_alaqar/features/office_properties/domain/usecases/update_property_status_usecase.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/usecases/get_office_properties_usecase.dart';
import '../../domain/usecases/get_property_stats_usecase.dart';
import '../../domain/usecases/delete_property_usecase.dart';
import 'office_properties_state.dart';

class OfficePropertiesCubit extends Cubit<OfficePropertiesState> {
  final GetOfficePropertiesUseCase getOfficePropertiesUseCase;
  final GetPropertyStatsUseCase getPropertyStatsUseCase;
  final DeletePropertyUseCase deletePropertyUseCase;
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final UpdatePropertyStatusUseCase updatePropertyStatusUseCase;

  static const int _perPage = 15;

  // Search parameters
  String? _search;
  int? _propertyTypeId;
  int? _offerTypeId;
  int? _governorateId;
  int? _districtId;
  int? _neighborhoodId;
  double? _minPrice;
  double? _maxPrice;

  OfficePropertiesCubit({
    required this.getOfficePropertiesUseCase,
    required this.getPropertyStatsUseCase,
    required this.deletePropertyUseCase,
    required this.getPropertyDetailsUseCase,
    required this.updatePropertyStatusUseCase,
  }) : super(const OfficePropertiesInitial());

  factory OfficePropertiesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficePropertiesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficePropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final getPropertiesUseCase = GetOfficePropertiesUseCase(repository);
    final getStatsUseCase = GetPropertyStatsUseCase(repository);
    final deleteUseCase = DeletePropertyUseCase(repository);
    final getPropertyDetailsUseCase = GetPropertyDetailsUseCase(repository);
    final updateStatusUseCase = UpdatePropertyStatusUseCase(repository);
    return OfficePropertiesCubit(
      getOfficePropertiesUseCase: getPropertiesUseCase,
      getPropertyStatsUseCase: getStatsUseCase,
      deletePropertyUseCase: deleteUseCase,
      getPropertyDetailsUseCase: getPropertyDetailsUseCase,
      updatePropertyStatusUseCase: updateStatusUseCase,
    );
  }

  Future<void> getOfficeProperties({
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
    if (refresh) {
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

    emit(const OfficePropertiesLoading());
    final result = await getOfficePropertiesUseCase(
      page: 1,
      perPage: _perPage,
      search: _search,
      propertyTypeId: _propertyTypeId,
      offerTypeId: _offerTypeId,
      governorateId: _governorateId,
      districtId: _districtId,
      neighborhoodId: _neighborhoodId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );
    result.fold(
      (failure) => emit(OfficePropertiesError(message: failure.errMessage)),
      (response) {
        emit(
          OfficePropertiesSuccess(
            properties: response.properties,
            currentPage: response.currentPage,
            lastPage: response.lastPage,
            total: response.total,
          ),
        );
        // Load stats after properties are loaded
        getPropertyStats();
      },
    );
  }

  Future<void> getPropertyStats() async {
    final currentState = state;
    if (currentState is OfficePropertiesSuccess) {
      emit(currentState.copyWith(isLoadingStats: true));

      final result = await getPropertyStatsUseCase();

      result.fold(
        (failure) {
          // Keep the current state but mark stats loading as complete
          emit(currentState.copyWith(isLoadingStats: false));
        },
        (stats) {
          emit(currentState.copyWith(stats: stats, isLoadingStats: false));
        },
      );
    }
  }

  Future<bool> deleteProperty(int propertyId) async {
    final currentState = state;
    if (currentState is! OfficePropertiesSuccess) return false;

    // Set deleting state
    emit(currentState.copyWith(deletingPropertyId: propertyId));

    final result = await deletePropertyUseCase(propertyId);

    return result.fold(
      (failure) {
        emit(
          OfficePropertiesDeleteError(
            message: failure.errMessage,
            properties: currentState.properties,
            currentPage: currentState.currentPage,
            lastPage: currentState.lastPage,
            total: currentState.total,
            stats: currentState.stats,
          ),
        );
        return false;
      },
      (message) {
        // Remove the deleted property from the list
        final updatedProperties = currentState.properties
            .where((property) => property.id != propertyId)
            .toList();

        emit(
          OfficePropertiesSuccess(
            properties: updatedProperties,
            currentPage: currentState.currentPage,
            lastPage: currentState.lastPage,
            total: currentState.total - 1,
            stats: currentState.stats,
            deleteSuccessMessage: message,
            deletingPropertyId: null,
          ),
        );

        // Refresh stats after deletion
        getPropertyStats();

        return true;
      },
    );
  }

  void clearDeleteMessage() {
    final currentState = state;
    if (currentState is OfficePropertiesSuccess &&
        currentState.deleteSuccessMessage != null) {
      emit(currentState.copyWith(deleteSuccessMessage: ''));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! OfficePropertiesSuccess) return;
    if (currentState.currentPage >= currentState.lastPage) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getOfficePropertiesUseCase(
      page: nextPage,
      perPage: _perPage,
      search: _search,
      propertyTypeId: _propertyTypeId,
      offerTypeId: _offerTypeId,
      governorateId: _governorateId,
      districtId: _districtId,
      neighborhoodId: _neighborhoodId,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
    );

    result.fold(
      (failure) => emit(
        OfficePropertiesLoadMoreError(
          message: failure.errMessage,
          properties: currentState.properties,
          currentPage: currentState.currentPage,
          lastPage: currentState.lastPage,
          total: currentState.total,
        ),
      ),
      (response) => emit(
        OfficePropertiesSuccess(
          properties: [...currentState.properties, ...response.properties],
          currentPage: response.currentPage,
          lastPage: response.lastPage,
          total: response.total,
          stats: currentState.stats,
        ),
      ),
    );
  }

  Future<void> refresh() => getOfficeProperties(refresh: true);

  void clearFilters() {
    _search = null;
    _propertyTypeId = null;
    _offerTypeId = null;
    _governorateId = null;
    _districtId = null;
    _neighborhoodId = null;
    _minPrice = null;
    _maxPrice = null;
    getOfficeProperties(refresh: true);
  }

  bool get hasActiveFilters =>
      _search != null ||
      _propertyTypeId != null ||
      _offerTypeId != null ||
      _governorateId != null ||
      _districtId != null ||
      _neighborhoodId != null ||
      _minPrice != null ||
      _maxPrice != null;

  Future<void> getPropertyDetails({required int propertyId}) async {
    emit(const OfficePropertyDetailsLoading());
    final result = await getPropertyDetailsUseCase(propertyId: propertyId);
    result.fold(
      (failure) =>
          emit(OfficePropertyDetailsError(message: failure.errMessage)),
      (response) => emit(OfficePropertyDetailsSuccess(property: response.data)),
    );
  }

  Future<void> refreshPropertyDetails({required int propertyId}) =>
      getPropertyDetails(propertyId: propertyId);

  Future<bool> updatePropertyStatus({
    required int propertyId,
    required String status,
  }) async {
    final currentState = state;

    // If we're in property details view, handle that separately
    if (currentState is OfficePropertyDetailsSuccess) {
      emit(
        OfficePropertyDetailsUpdatingStatus(property: currentState.property),
      );

      final result = await updatePropertyStatusUseCase(
        propertyId: propertyId,
        status: status,
      );

      return result.fold(
        (failure) {
          emit(
            OfficePropertyDetailsUpdateStatusError(
              message: failure.errMessage,
              property: currentState.property,
            ),
          );
          return false;
        },
        (response) {
          emit(OfficePropertyDetailsSuccess(property: response.data));
          return true;
        },
      );
    }

    // If we're in the list view
    if (currentState is OfficePropertiesSuccess) {
      // Mark the property as updating
      emit(currentState.copyWith(updatingStatusPropertyId: propertyId));

      final result = await updatePropertyStatusUseCase(
        propertyId: propertyId,
        status: status,
      );

      return result.fold(
        (failure) {
          emit(
            OfficePropertiesUpdateStatusError(
              message: failure.errMessage,
              properties: currentState.properties,
              currentPage: currentState.currentPage,
              lastPage: currentState.lastPage,
              total: currentState.total,
              stats: currentState.stats,
            ),
          );
          return false;
        },
        (response) {
          // Update the property in the list with the new status
          final updatedProperties = currentState.properties.map((property) {
            if (property.id == propertyId) {
              return property.copyWith(status: response.data.status);
            }
            return property;
          }).toList();

          emit(
            OfficePropertiesSuccess(
              properties: updatedProperties,
              currentPage: currentState.currentPage,
              lastPage: currentState.lastPage,
              total: currentState.total,
              stats: currentState.stats,
              updateStatusSuccessMessage: response.message,
              updatingStatusPropertyId: null,
            ),
          );

          // Refresh stats after status update
          getPropertyStats();

          return true;
        },
      );
    }

    return false;
  }

  void clearUpdateStatusMessage() {
    final currentState = state;
    if (currentState is OfficePropertiesSuccess &&
        currentState.updateStatusSuccessMessage != null) {
      emit(currentState.copyWith(updateStatusSuccessMessage: ''));
    }
  }
}
