import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import '../../data/datasources/office_info_remote_data_source.dart';
import '../../data/repositories/office_info_repository_impl.dart';
import '../../domain/usecases/get_office_info_usecase.dart';
import '../../domain/usecases/update_office_info_usecase.dart';
import 'office_info_state.dart';

class OfficeInfoCubit extends Cubit<OfficeInfoState> {
  final GetOfficeInfoUseCase getOfficeInfoUseCase;
  final UpdateOfficeInfoUseCase updateOfficeInfoUseCase;

  OfficeInfoCubit({
    required this.getOfficeInfoUseCase,
    required this.updateOfficeInfoUseCase,
  }) : super(const OfficeInfoInitial());

  factory OfficeInfoCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final remoteDataSource = OfficeInfoRemoteDataSourceImpl(
      apiConsumer: apiConsumer,
    );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final repository = OfficeInfoRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final getUseCase = GetOfficeInfoUseCase(repository);
    final updateUseCase = UpdateOfficeInfoUseCase(repository);
    return OfficeInfoCubit(
      getOfficeInfoUseCase: getUseCase,
      updateOfficeInfoUseCase: updateUseCase,
    );
  }

  Future<void> getOfficeInfo() async {
    emit(const OfficeInfoLoading());
    final result = await getOfficeInfoUseCase();
    result.fold(
      (failure) => emit(OfficeInfoError(message: failure.errMessage)),
      (officeInfo) => emit(OfficeInfoSuccess(officeInfo: officeInfo)),
    );
  }

  Future<void> updateOfficeInfo(Map<String, dynamic> updateData) async {
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

  Future<void> refresh() => getOfficeInfo();
}
