import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/usecases/get_property_details_usecase.dart';
import 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  final GetPropertyDetailsUseCase getPropertyDetailsUseCase;

  PropertyDetailsCubit({required this.getPropertyDetailsUseCase})
    : super(const PropertyDetailsInitial());

  factory PropertyDetailsCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficePropertiesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficePropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = GetPropertyDetailsUseCase(repository);
    return PropertyDetailsCubit(getPropertyDetailsUseCase: useCase);
  }

  Future<void> getPropertyDetails(int propertyId) async {
    emit(const PropertyDetailsLoading());

    final result = await getPropertyDetailsUseCase(propertyId: propertyId);

    result.fold(
      (failure) => emit(PropertyDetailsError(message: failure.errMessage)),
      (response) => emit(PropertyDetailsSuccess(property: response.data)),
    );
  }
}
