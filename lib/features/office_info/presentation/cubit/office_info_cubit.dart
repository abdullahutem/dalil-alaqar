import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import '../../data/datasources/office_info_local_data_source.dart';
import '../../data/datasources/office_info_remote_data_source.dart';
import '../../data/repositories/office_info_repository_impl.dart';
import '../../domain/usecases/get_office_info_usecase.dart';
import '../../domain/usecases/update_office_info_usecase.dart';
import '../../domain/usecases/upload_office_logo_usecase.dart';
import 'office_info_state.dart';

class OfficeInfoCubit extends Cubit<OfficeInfoState> {
  final GetOfficeInfoUseCase getOfficeInfoUseCase;
  final UpdateOfficeInfoUseCase updateOfficeInfoUseCase;
  final UploadOfficeLogoUseCase uploadOfficeLogoUseCase;

  OfficeInfoCubit({
    required this.getOfficeInfoUseCase,
    required this.updateOfficeInfoUseCase,
    required this.uploadOfficeLogoUseCase,
  }) : super(const OfficeInfoInitial());

  factory OfficeInfoCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficeInfoRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final localDataSource = OfficeInfoLocalDataSourceImpl(
      databaseHelper: DatabaseHelper.instance,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficeInfoRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final getUseCase = GetOfficeInfoUseCase(repository);
    final updateUseCase = UpdateOfficeInfoUseCase(repository);
    final uploadLogoUseCase = UploadOfficeLogoUseCase(repository);
    return OfficeInfoCubit(
      getOfficeInfoUseCase: getUseCase,
      updateOfficeInfoUseCase: updateUseCase,
      uploadOfficeLogoUseCase: uploadLogoUseCase,
    );
  }

  Future<void> getOfficeInfo() async {
    if (isClosed) return;
    emit(const OfficeInfoLoading());
    final result = await getOfficeInfoUseCase();
    if (isClosed) return;
    result.fold(
      (failure) => emit(OfficeInfoError(message: failure.errMessage)),
      (officeInfo) => emit(OfficeInfoSuccess(officeInfo: officeInfo)),
    );
  }

  Future<void> updateOfficeInfo(Map<String, dynamic> updateData) async {
    if (isClosed) return;
    emit(const OfficeInfoUpdating());
    final result = await updateOfficeInfoUseCase(updateData);
    result.fold(
      (failure) => emit(OfficeInfoUpdateError(message: failure.errMessage)),
      (officeInfo) {
        // Emit update success first for the update screen to show success message
        emit(
          OfficeInfoUpdateSuccess(
            officeInfo: officeInfo,
            message: 'تم تحديث معلومات المكتب بنجاح',
          ),
        );
        // Then immediately emit the regular success state so the main screen displays the data
        emit(OfficeInfoSuccess(officeInfo: officeInfo));
      },
    );
  }

  Future<void> uploadOfficeLogo(String filePath) async {
    if (isClosed) return;
    emit(const OfficeLogoUploading());
    final result = await uploadOfficeLogoUseCase(filePath);
    result.fold(
      (failure) => emit(OfficeLogoUploadError(message: failure.errMessage)),
      (logoData) {
        emit(
          OfficeLogoUploadSuccess(
            logo: logoData['logo']!,
            logoUrl: logoData['logo_url']!,
            message: 'تم رفع شعار المكتب بنجاح',
          ),
        );
        // Refresh office info to get the updated logo
        getOfficeInfo();
      },
    );
  }

  Future<void> refresh() => getOfficeInfo();
}
