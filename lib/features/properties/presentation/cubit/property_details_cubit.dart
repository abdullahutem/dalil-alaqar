import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_local_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/property_details_local_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/repositories/properties_repository_impl.dart';
import 'package:dalil_alaqar/features/properties/domain/usecases/get_property_details_usecase.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;

  PropertyDetailsCubit({required this.getPropertyDetailsUseCase})
    : super(PropertyDetailsInitial());

  factory PropertyDetailsCubit.create() {
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
    final GetPropertyDetailsUseCase getPropertyDetailsUseCase =
        GetPropertyDetailsUseCase(repository: repository);

    return PropertyDetailsCubit(
      getPropertyDetailsUseCase: getPropertyDetailsUseCase,
    );
  }

  Future<void> getPropertyDetails({required int id}) async {
    emit(PropertyDetailsLoading());

    final result = await getPropertyDetailsUseCase(id: id);

    result.fold(
      (failure) => emit(PropertyDetailsError(message: failure.errMessage)),
      (property) => emit(PropertyDetailsSuccess(property: property)),
    );
  }
}
