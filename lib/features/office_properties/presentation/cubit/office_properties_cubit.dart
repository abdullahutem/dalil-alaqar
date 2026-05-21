import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/features/office_properties/domain/usecases/get_property_details_usecase.dart';
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

  static const int _perPage = 15;

  OfficePropertiesCubit({
    required this.getOfficePropertiesUseCase,
    required this.getPropertyStatsUseCase,
    required this.deletePropertyUseCase,
    required this.getPropertyDetailsUseCase,
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
    return OfficePropertiesCubit(
      getOfficePropertiesUseCase: getPropertiesUseCase,
      getPropertyStatsUseCase: getStatsUseCase,
      deletePropertyUseCase: deleteUseCase,
      getPropertyDetailsUseCase: getPropertyDetailsUseCase,
    );
  }

  Future<void> getOfficeProperties() async {
    emit(const OfficePropertiesLoading());
    final result = await getOfficePropertiesUseCase(page: 1, perPage: _perPage);
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

  Future<void> refresh() => getOfficeProperties();

  Future<void> getPropertyDetails({required int propertyId}) async {
    emit(const PropertyDetailsLoading());
    final result = await getPropertyDetailsUseCase(propertyId: propertyId);
    result.fold(
      (failure) => emit(PropertyDetailsError(message: failure.errMessage)),
      (response) => emit(PropertyDetailsSuccess(property: response.data)),
    );
  }

  Future<void> refreshPropertyDetails({required int propertyId}) =>
      getPropertyDetails(propertyId: propertyId);
}
