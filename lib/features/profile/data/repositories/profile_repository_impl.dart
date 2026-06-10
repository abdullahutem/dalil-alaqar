import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/entities/update_profile_params.dart';
import '../../domain/entities/updated_user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    // CACHE-FIRST STRATEGY: Load cache immediately for instant display
    ProfileEntity? cachedProfile;
    try {
      cachedProfile = await localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        AppLogger.success('Loaded profile from cache (instant)', 'Profile');
      }
    } catch (e) {
      AppLogger.warning('Failed to load cache: $e', 'Profile');
    }

    // Check if we're online
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from network
        final freshProfile = await remoteDataSource.getProfile();

        // Cache the fresh data in background
        try {
          await localDataSource.cacheProfile(freshProfile);
          AppLogger.success('Updated profile cache from API', 'Profile');
        } catch (e) {
          AppLogger.warning('Failed to update cache: $e', 'Profile');
        }

        // Return fresh data
        return Right(freshProfile);
      } on ServerException catch (e) {
        AppLogger.error('ServerException fetching profile', 'Profile', e);
        // API failed, return cache if available
        if (cachedProfile != null) {
          return Right(cachedProfile);
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        AppLogger.error('Error fetching profile', 'Profile', e, stackTrace);
        // API failed, return cache if available
        if (cachedProfile != null) {
          return Right(cachedProfile);
        }
        return Left(
          ServerFailure(errMessage: 'حدث خطأ أثناء تحميل الملف الشخصي'),
        );
      }
    } else {
      // Offline: return cache or error
      if (cachedProfile != null) {
        return Right(cachedProfile);
      }
      return Left(
        CacheFailure(message: 'لا توجد بيانات محفوظة. يرجى الاتصال بالإنترنت.'),
      );
    }
  }

  @override
  Future<Either<Failure, UpdatedUserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final updatedUser = await remoteDataSource.updateProfile(params);

        // After updating, refresh the cached profile
        try {
          // Fetch fresh profile to update cache
          final freshProfile = await remoteDataSource.getProfile();
          await localDataSource.cacheProfile(freshProfile);
          AppLogger.success('Updated profile cache after edit', 'Profile');
        } catch (e) {
          AppLogger.warning('Failed to update cache after edit: $e', 'Profile');
        }

        return Right(updatedUser);
      } on ServerException catch (e) {
        AppLogger.error('ServerException updating profile', 'Profile', e);
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        AppLogger.error('Error updating profile', 'Profile', e, stackTrace);
        return Left(
          ServerFailure(errMessage: 'حدث خطأ أثناء تحديث الملف الشخصي'),
        );
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
