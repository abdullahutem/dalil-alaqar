import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/entities/update_property_entity.dart';
import '../../domain/usecases/update_property_usecase.dart';
import 'update_property_state.dart';

class UpdatePropertyCubit extends Cubit<UpdatePropertyState> {
  final UpdatePropertyUseCase updatePropertyUseCase;

  UpdatePropertyCubit(this.updatePropertyUseCase)
    : super(UpdatePropertyInitial());

  factory UpdatePropertyCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficePropertiesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficePropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = UpdatePropertyUseCase(repository);
    return UpdatePropertyCubit(useCase);
  }

  Future<void> updateProperty({
    required int propertyId,
    required String title,
    required int propertyTypeId,
    required int offerTypeId,
    required String description,
    required int governorateId,
    required int districtId,
    required int neighborhoodId,
    required String address,
    required double price,
    required bool priceNegotiable,
    required int currencyId,
  }) async {
    emit(UpdatePropertyLoading());

    final updateEntity = UpdatePropertyEntity(
      propertyId: propertyId,
      title: title,
      propertyTypeId: propertyTypeId,
      offerTypeId: offerTypeId,
      description: description,
      governorateId: governorateId,
      districtId: districtId,
      neighborhoodId: neighborhoodId,
      address: address,
      price: price,
      priceNegotiable: priceNegotiable,
      currencyId: currencyId,
    );

    final result = await updatePropertyUseCase.call(property: updateEntity);

    result.fold(
      (failure) => emit(UpdatePropertyFailure(failure.errMessage)),
      (response) => emit(UpdatePropertySuccess(response)),
    );
  }

  void reset() {
    emit(UpdatePropertyInitial());
  }
}
