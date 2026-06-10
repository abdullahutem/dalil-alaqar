import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:dalil_alaqar/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:dalil_alaqar/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:dalil_alaqar/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // إحصائيات لوحة التحكم تتغير بشكل متكرر، لذا نستخدم كاش قصير (6 ساعات)
    final cachedData = _cacheManager.getCachedDashboardStatsData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final dashboardStats = DashboardStatsModel.fromJson(jsonData);

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(dashboardStats);
      } catch (e) {
        print('Error parsing cached dashboard stats data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final DashboardStatsModel stats = await remoteDataSource
            .getDashboardStats();

        // Cache the dashboard stats locally in SQLite
        await localDataSource.cacheDashboardStats(stats);

        // Cache in SharedPreferences for faster access
        final jsonData = stats.toJson();
        await _cacheManager.cacheDashboardStatsData(json.encode(jsonData));

        return Right(stats);
      } on ServerException catch (e) {
        print('ServerException: $e');
        // If API fails, try to load from SQLite cache
        return await _loadFromCache();
      } on DioException catch (e) {
        print('DioException: $e');
        // If network error occurs, try to load from SQLite cache
        return await _loadFromCache();
      } catch (e, stackTrace) {
        // If any other error occurs, log it and try to load from SQLite cache
        print('Error fetching dashboard stats: $e');
        print('Stack trace: $stackTrace');
        return await _loadFromCache();
      }
    } else {
      // No internet connection, load from SQLite cache
      return await _loadFromCache();
    }
  }

  /// تحديث الكاش في الخلفية دون انتظار
  Future<void> _updateCacheInBackground() async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final DashboardStatsModel stats = await remoteDataSource
            .getDashboardStats();

        await localDataSource.cacheDashboardStats(stats);

        final jsonData = stats.toJson();
        await _cacheManager.cacheDashboardStatsData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, DashboardStatsEntity>> _loadFromCache() async {
    try {
      final cachedStats = await localDataSource.getCachedDashboardStats();

      if (cachedStats == null) {
        return Left(
          CacheFailure(
            message: 'لا توجد إحصائيات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      return Right(cachedStats);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
