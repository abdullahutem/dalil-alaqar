import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import '../../domain/entities/office_info_entity.dart';
import '../../domain/repositories/office_info_repository.dart';
import '../datasources/office_info_local_data_source.dart';
import '../datasources/office_info_remote_data_source.dart';

class OfficeInfoRepositoryImpl implements OfficeInfoRepository {
  final OfficeInfoRemoteDataSource remoteDataSource;
  final OfficeInfoLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  OfficeInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfficeInfoEntity>> getOfficeInfo() async {
    // CACHE-FIRST STRATEGY: Load cache immediately for instant display
    OfficeInfoEntity? cachedOfficeInfo;
    try {
      cachedOfficeInfo = await localDataSource.getCachedOfficeInfo();
      if (cachedOfficeInfo != null) {
        AppLogger.success(
          'Loaded office info from cache (instant)',
          'OfficeInfo',
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to load cache: $e', 'OfficeInfo');
    }

    // Check if we're online
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from network
        final freshOfficeInfo = await remoteDataSource.getOfficeInfo();

        // Cache the fresh data in background
        try {
          await localDataSource.cacheOfficeInfo(freshOfficeInfo);
          AppLogger.success('Updated office info cache from API', 'OfficeInfo');
        } catch (e) {
          AppLogger.warning('Failed to update cache: $e', 'OfficeInfo');
        }

        // Return fresh data
        return Right(freshOfficeInfo);
      } on ServerException catch (e) {
        AppLogger.error(
          'ServerException fetching office info',
          'OfficeInfo',
          e,
        );
        // API failed, return cache if available
        if (cachedOfficeInfo != null) {
          return Right(cachedOfficeInfo);
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        AppLogger.error(
          'Error fetching office info',
          'OfficeInfo',
          e,
          stackTrace,
        );
        // API failed, return cache if available
        if (cachedOfficeInfo != null) {
          return Right(cachedOfficeInfo);
        }
        return Left(
          ServerFailure(errMessage: 'حدث خطأ أثناء تحميل معلومات المكتب'),
        );
      }
    } else {
      // Offline: return cache or error
      if (cachedOfficeInfo != null) {
        return Right(cachedOfficeInfo);
      }
      return Left(
        CacheFailure(
          message: 'لا توجد معلومات محفوظة. يرجى الاتصال بالإنترنت.',
        ),
      );
    }
  }

  @override
  Future<Either<Failure, OfficeInfoEntity>> updateOfficeInfo(
    Map<String, dynamic> updateData,
  ) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.updateOfficeInfo(updateData);

      // Update cache after successful update
      try {
        await localDataSource.cacheOfficeInfo(result);
        AppLogger.success('Updated office info cache after edit', 'OfficeInfo');
      } catch (e) {
        AppLogger.warning(
          'Failed to update cache after edit: $e',
          'OfficeInfo',
        );
      }

      return Right(result);
    } on ServerException catch (e) {
      AppLogger.error('ServerException updating office info', 'OfficeInfo', e);
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error updating office info',
        'OfficeInfo',
        e,
        stackTrace,
      );
      return Left(
        ServerFailure(errMessage: 'حدث خطأ أثناء تحديث معلومات المكتب'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> uploadOfficeLogo(
    String filePath,
  ) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.uploadOfficeLogo(filePath);
      AppLogger.success('Office logo uploaded successfully', 'OfficeInfo');
      return Right({'logo': result.logo, 'logo_url': result.logoUrl});
    } on ServerException catch (e) {
      AppLogger.error('ServerException uploading logo', 'OfficeInfo', e);
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error uploading office logo',
        'OfficeInfo',
        e,
        stackTrace,
      );
      return Left(ServerFailure(errMessage: 'حدث خطأ أثناء رفع الشعار'));
    }
  }
}
