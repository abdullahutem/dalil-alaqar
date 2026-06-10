import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_local_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/repositories/property_types_repository_impl.dart';
import 'package:dalil_alaqar/features/property_types/domain/usecases/get_property_types_usecase.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_state.dart';

class PropertyTypesCubit extends Cubit<PropertyTypesState> {
  final GetPropertyTypesUseCase getPropertyTypesUseCase;

  PropertyTypesCubit({required this.getPropertyTypesUseCase})
    : super(PropertyTypesInitial());

  factory PropertyTypesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final PropertyTypesRemoteDataSource remoteDataSource =
        PropertyTypesRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final PropertyTypesLocalDataSource localDataSource =
        PropertyTypesLocalDataSourceImpl(
          databaseHelper: DatabaseHelper.instance,
        );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final PropertyTypesRepositoryImpl repository = PropertyTypesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetPropertyTypesUseCase getPropertyTypesUseCase =
        GetPropertyTypesUseCase(repository: repository);

    return PropertyTypesCubit(getPropertyTypesUseCase: getPropertyTypesUseCase);
  }

  Future<void> getPropertyTypes() async {
    emit(PropertyTypesLoading());

    final result = await getPropertyTypesUseCase();

    result.fold(
      (failure) => emit(PropertyTypesError(message: failure.errMessage)),
      (response) => emit(PropertyTypesSuccess(response: response)),
    );
  }
}
