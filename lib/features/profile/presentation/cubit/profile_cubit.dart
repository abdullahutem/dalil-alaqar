import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/dio_consumer.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial());

  factory ProfileCubit.create() {
    final ApiConsumer apiConsumer = DioConsumer(dio: Dio());
    final ProfileRemoteDataSource remoteDataSource =
        ProfileRemoteDataSourceImpl(apiConsumer: apiConsumer);
    final NetworkInfo networkInfo = NetworkInfoImpl(DataConnectionChecker());
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );
    final GetProfileUseCase getProfileUseCase = GetProfileUseCase(
      repository: repository,
    );
    final UpdateProfileUseCase updateProfileUseCase = UpdateProfileUseCase(
      repository: repository,
    );

    return ProfileCubit(
      getProfileUseCase: getProfileUseCase,
      updateProfileUseCase: updateProfileUseCase,
    );
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());

    final result = await getProfileUseCase.call();

    result.fold(
      (failure) => emit(ProfileError(message: failure.errMessage)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> updateProfile(UpdateProfileParams params) async {
    emit(ProfileUpdating());

    final result = await updateProfileUseCase.call(params);

    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.errMessage)),
      (updatedUser) {
        emit(ProfileUpdated(updatedUser: updatedUser));
        // Reload profile after successful update
        getProfile();
      },
    );
  }
}
