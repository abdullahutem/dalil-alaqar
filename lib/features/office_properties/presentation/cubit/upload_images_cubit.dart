import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/office_properties_remote_data_source.dart';
import '../../data/repositories/office_properties_repository_impl.dart';
import '../../domain/usecases/upload_property_images_usecase.dart';
import 'upload_images_state.dart';

class UploadImagesCubit extends Cubit<UploadImagesState> {
  final UploadPropertyImagesUseCase uploadPropertyImagesUseCase;

  UploadImagesCubit({required this.uploadPropertyImagesUseCase})
    : super(const UploadImagesInitial());

  factory UploadImagesCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficePropertiesRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficePropertiesRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final useCase = UploadPropertyImagesUseCase(repository);
    return UploadImagesCubit(uploadPropertyImagesUseCase: useCase);
  }

  Future<void> uploadImages({
    required int propertyId,
    required List<String> imagePaths,
  }) async {
    emit(const UploadImagesLoading());

    final result = await uploadPropertyImagesUseCase(
      propertyId: propertyId,
      imagePaths: imagePaths,
    );

    result.fold(
      (failure) => emit(UploadImagesError(message: failure.errMessage)),
      (response) => emit(
        UploadImagesSuccess(
          message: response.message,
          uploadedImages: response.data,
        ),
      ),
    );
  }

  void resetState() {
    emit(const UploadImagesInitial());
  }
}
