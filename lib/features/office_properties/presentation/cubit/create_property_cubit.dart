import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_list_local_data_source.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/datasources/office_property_details_local_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/entities/create_property_entity.dart';
import '../../domain/usecases/create_property_usecase.dart';
import 'create_property_state.dart';

class CreatePropertyCubit extends Cubit<CreatePropertyState> {
  final CreatePropertyUseCase createPropertyUseCase;

  CreatePropertyCubit({required this.createPropertyUseCase})
    : super(const CreatePropertyInitial());

  factory CreatePropertyCubit.create() {
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
    final useCase = CreatePropertyUseCase(repository);
    return CreatePropertyCubit(createPropertyUseCase: useCase);
  }

  Future<void> createProperty(CreatePropertyEntity property) async {
    // Validate before submission
    final validationErrors = _validateProperty(property);
    if (validationErrors.isNotEmpty) {
      emit(CreatePropertyValidationError(errors: validationErrors));
      return;
    }

    emit(const CreatePropertyLoading());

    final result = await createPropertyUseCase(property: property);

    result.fold(
      (failure) => emit(CreatePropertyError(message: failure.errMessage)),
      (response) => emit(
        CreatePropertySuccess(
          property: response.data,
          message: response.message,
        ),
      ),
    );
  }

  Map<String, String> _validateProperty(CreatePropertyEntity property) {
    final errors = <String, String>{};

    // Validate title
    if (property.title.trim().isEmpty) {
      errors['title'] = 'العنوان مطلوب';
    } else if (property.title.trim().length < 10) {
      errors['title'] = 'العنوان يجب أن يكون 10 أحرف على الأقل';
    } else if (property.title.length > 200) {
      errors['title'] = 'العنوان يجب ألا يزيد عن 200 حرف';
    }

    // Validate description
    if (property.description.trim().isEmpty) {
      errors['description'] = 'الوصف مطلوب';
    } else if (property.description.trim().length < 20) {
      errors['description'] = 'الوصف يجب أن يكون 20 حرف على الأقل';
    } else if (property.description.length > 1000) {
      errors['description'] = 'الوصف يجب ألا يزيد عن 1000 حرف';
    }

    // Validate price
    if (property.price <= 0) {
      errors['price'] = 'السعر يجب أن يكون أكبر من صفر';
    }

    // Validate address
    if (property.address.trim().isEmpty) {
      errors['address'] = 'العنوان مطلوب';
    }

    // Validate coordinates
    if (property.latitude < -90 || property.latitude > 90) {
      errors['latitude'] = 'خط العرض غير صحيح';
    }
    if (property.longitude < -180 || property.longitude > 180) {
      errors['longitude'] = 'خط الطول غير صحيح';
    }

    // Validate property type
    if (property.propertyTypeId <= 0) {
      errors['propertyType'] = 'نوع العقار مطلوب';
    }

    // Validate offer type
    if (property.offerTypeId <= 0) {
      errors['offerType'] = 'نوع العرض مطلوب';
    }

    // Validate geographic selection
    if (property.governorateId <= 0) {
      errors['governorate'] = 'المحافظة مطلوبة';
    }
    if (property.districtId <= 0) {
      errors['district'] = 'المديرية مطلوبة';
    }
    if (property.neighborhoodId <= 0) {
      errors['neighborhood'] = 'الحي مطلوب';
    }

    return errors;
  }

  void resetState() {
    emit(const CreatePropertyInitial());
  }
}
