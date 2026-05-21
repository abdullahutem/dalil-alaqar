import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import '../../data/datasources/office_info_remote_data_source.dart';
import '../../data/repositories/office_info_repository_impl.dart';
import '../../domain/usecases/get_office_info_usecase.dart';
import 'office_info_state.dart';

class OfficeInfoCubit extends Cubit<OfficeInfoState> {
  final GetOfficeInfoUseCase getOfficeInfoUseCase;

  OfficeInfoCubit({required this.getOfficeInfoUseCase})
    : super(const OfficeInfoInitial());

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
    final useCase = GetOfficeInfoUseCase(repository);
    return OfficeInfoCubit(getOfficeInfoUseCase: useCase);
  }

  Future<void> getOfficeInfo() async {
    emit(const OfficeInfoLoading());
    final result = await getOfficeInfoUseCase();
    result.fold(
      (failure) => emit(OfficeInfoError(message: failure.errMessage)),
      (officeInfo) => emit(OfficeInfoSuccess(officeInfo: officeInfo)),
    );
  }

  Future<void> refresh() => getOfficeInfo();
}
