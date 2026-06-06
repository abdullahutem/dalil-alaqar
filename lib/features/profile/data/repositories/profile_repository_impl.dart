import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/updated_user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final profile = await remoteDataSource.getProfile();
        return Right(profile);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, UpdatedUserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final updatedUser = await remoteDataSource.updateProfile(params);
        return Right(updatedUser);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
