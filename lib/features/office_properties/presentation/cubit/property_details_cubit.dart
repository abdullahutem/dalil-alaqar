import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/office_properties/data/datasources/office_properties_list_local_data_source.dart';
import 'package:dalil_alaqar/features/office_properties/data/datasources/office_property_details_local_data_source.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/usecases/delete_property_image_usecase.dart';
import '../../domain/usecases/get_property_details_usecase.dart';
import '../../domain/usecases/set_primary_image_usecase.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;
  final SetPrimaryImageUseCase setPrimaryImageUseCase;
  final DeletePropertyImageUseCase deletePropertyImageUseCase;

  PropertyDetailsCubit({
    required this.getPropertyDetailsUseCase,
    required this.setPrimaryImageUseCase,
    required this.deletePropertyImageUseCase,
  }) : super(const PropertyDetailsInitial());

  factory PropertyDetailsCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficePropertiesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final listLocalDataSource = OfficePropertiesListLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final detailsLocalDataSource = OfficePropertyDetailsLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());

    final repository = OfficePropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      listLocalDataSource: listLocalDataSource,
      detailsLocalDataSource: detailsLocalDataSource,
      networkInfo: networkInfo,
    );
    final getDetailsUseCase = GetPropertyDetailsUseCase(repository);
    final setPrimaryUseCase = SetPrimaryImageUseCase(repository);
    final deleteImageUseCase = DeletePropertyImageUseCase(repository);
    return PropertyDetailsCubit(
      getPropertyDetailsUseCase: getDetailsUseCase,
      setPrimaryImageUseCase: setPrimaryUseCase,
      deletePropertyImageUseCase: deleteImageUseCase,
    );
  }

  Future<void> getPropertyDetails(int propertyId) async {
    emit(const PropertyDetailsLoading());

    try {
      final result = await getPropertyDetailsUseCase(propertyId: propertyId);
      result.fold(
        (failure) => emit(PropertyDetailsError(message: failure.errMessage)),
        (response) => emit(PropertyDetailsSuccess(property: response.data)),
      );
    } catch (e) {
      emit(PropertyDetailsError(message: e.toString()));
    }
  }

  Future<bool> setPrimaryImage(int propertyId, int imageId) async {
    final result = await setPrimaryImageUseCase(
      propertyId: propertyId,
      imageId: imageId,
    );

    return result.fold((failure) => false, (message) {
      // Silently refresh property details in background without showing loading state
      _refreshPropertyDetailsInBackground(propertyId);
      return true;
    });
  }

  Future<void> _refreshPropertyDetailsInBackground(int propertyId) async {
    final result = await getPropertyDetailsUseCase(propertyId: propertyId);

    result.fold(
      (failure) {
        // Keep current state on error, don't disrupt user
      },
      (response) {
        // Only emit success state, no loading state to avoid disruption
        emit(PropertyDetailsSuccess(property: response.data));
      },
    );
  }

  Future<bool> deletePropertyImage(int propertyId, int imageId) async {
    final result = await deletePropertyImageUseCase(
      propertyId: propertyId,
      imageId: imageId,
    );

    return result.fold((failure) => false, (message) {
      // Silently refresh property details in background
      _refreshPropertyDetailsInBackground(propertyId);
      return true;
    });
  }
}
