import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/core/utils/app_logger.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/plans_repository.dart';
import '../datasources/plans_local_data_source.dart';
import '../datasources/plans_remote_data_source.dart';

class PlansRepositoryImpl implements PlansRepository {
  final PlansRemoteDataSource remoteDataSource;
  final PlansLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PlansRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PlanEntity>>> getPlans() async {
    // CACHE-FIRST STRATEGY: Load cache immediately for instant display
    List<PlanEntity>? cachedPlans;
    try {
      cachedPlans = await localDataSource.getCachedPlans();
      if (cachedPlans != null && cachedPlans.isNotEmpty) {
        AppLogger.success(
          'Loaded ${cachedPlans.length} plans from cache (instant)',
          'Plans',
        );
      }
    } catch (e) {
      AppLogger.warning('Failed to load cache: $e', 'Plans');
    }

    // Check if we're online
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from network
        final freshPlans = await remoteDataSource.getPlans();

        // Cache the fresh data in background
        try {
          await localDataSource.cachePlans(freshPlans);
          AppLogger.success('Updated plans cache from API', 'Plans');
        } catch (e) {
          AppLogger.warning('Failed to update cache: $e', 'Plans');
        }

        // Return fresh data
        return Right(freshPlans);
      } on ServerException catch (e) {
        AppLogger.error('ServerException fetching plans', 'Plans', e);
        // API failed, return cache if available
        if (cachedPlans != null && cachedPlans.isNotEmpty) {
          return Right(cachedPlans);
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        AppLogger.error('Error fetching plans', 'Plans', e, stackTrace);
        // API failed, return cache if available
        if (cachedPlans != null && cachedPlans.isNotEmpty) {
          return Right(cachedPlans);
        }
        return Left(ServerFailure(errMessage: 'حدث خطأ أثناء تحميل الباقات'));
      }
    } else {
      // Offline: return cache or error
      if (cachedPlans != null && cachedPlans.isNotEmpty) {
        return Right(cachedPlans);
      }
      return Left(
        CacheFailure(message: 'لا توجد باقات محفوظة. يرجى الاتصال بالإنترنت.'),
      );
    }
  }

  @override
  Future<Either<Failure, PlanEntity>> getPlanDetails(int planId) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final plan = await remoteDataSource.getPlanDetails(planId);
        return Right(plan);
      } on ServerException catch (e) {
        AppLogger.error('ServerException fetching plan details', 'Plans', e);
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } catch (e, stackTrace) {
        AppLogger.error('Error fetching plan details', 'Plans', e, stackTrace);
        return Left(
          ServerFailure(errMessage: 'حدث خطأ أثناء تحميل تفاصيل الباقة'),
        );
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
