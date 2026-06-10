import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/dio_consumer.dart';
import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/office_details/data/datasources/office_details_local_data_source.dart';
import 'package:dalil_alaqar/features/office_details/data/datasources/office_details_remote_data_source.dart';
import 'package:dalil_alaqar/features/office_details/data/repositories/office_details_repository_impl.dart';
import 'package:dalil_alaqar/features/office_details/domain/usecases/get_office_details_usecase.dart';
import 'package:dalil_alaqar/features/office_details/presentation/cubit/office_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfficeDetailsCubit extends Cubit<OfficeDetailsState> {
  final GetOfficeDetailsUseCase getOfficeDetailsUseCase;

  OfficeDetailsCubit({required this.getOfficeDetailsUseCase})
    : super(OfficeDetailsInitial());

  factory OfficeDetailsCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final OfficeDetailsRemoteDataSource remoteDataSource =
        OfficeDetailsRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final OfficeDetailsLocalDataSource localDataSource =
        OfficeDetailsLocalDataSourceImpl(
          databaseHelper: DatabaseHelper.instance,
        );
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final OfficeDetailsRepositoryImpl repository = OfficeDetailsRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    final GetOfficeDetailsUseCase getOfficeDetailsUseCase =
        GetOfficeDetailsUseCase(repository: repository);

    return OfficeDetailsCubit(getOfficeDetailsUseCase: getOfficeDetailsUseCase);
  }

  Future<void> getOfficeDetails(int officeId) async {
    emit(OfficeDetailsLoading());

    final result = await getOfficeDetailsUseCase(officeId);

    result.fold(
      (failure) {
        emit(OfficeDetailsError(message: failure.errMessage));
      },
      (officeDetails) {
        emit(OfficeDetailsSuccess(officeDetails: officeDetails));
      },
    );
  }
}
