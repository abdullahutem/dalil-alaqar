import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/governorates/data/datasources/governorates_local_data_source.dart';
import 'package:dalil_alaqar/features/governorates/data/datasources/governorates_remote_data_source.dart';
import 'package:dalil_alaqar/features/governorates/data/models/governorate_model.dart';
import 'package:dalil_alaqar/features/governorates/data/models/governorates_response_model.dart';
import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';
import 'package:dalil_alaqar/features/governorates/domain/repositories/governorates_repository.dart';

class GovernoratesRepositoryImpl implements GovernoratesRepository {
  final GovernoratesRemoteDataSource remoteDataSource;
  final GovernoratesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  GovernoratesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, GovernoratesResponseEntity>> getGovernorates() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // المحافظات نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedGovernoratesData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final governoratesResponse = GovernoratesResponseModel.fromJson(
          jsonData,
        );

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(governoratesResponse);
      } catch (e) {
        print('Error parsing cached governorates data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final GovernoratesResponseModel result = await remoteDataSource
            .getGovernorates();

        // Cache the governorates locally in SQLite
        final governorates = result.governorates
            .whereType<GovernorateModel>()
            .toList();
        await localDataSource.cacheGovernorates(governorates);

        // Cache in SharedPreferences for faster access
        final jsonData = result.toJson();
        await _cacheManager.cacheGovernoratesData(json.encode(jsonData));

        return Right(result);
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
        print('Error fetching governorates: $e');
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
        final GovernoratesResponseModel result = await remoteDataSource
            .getGovernorates();

        final governorates = result.governorates
            .whereType<GovernorateModel>()
            .toList();
        await localDataSource.cacheGovernorates(governorates);

        final jsonData = result.toJson();
        await _cacheManager.cacheGovernoratesData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, GovernoratesResponseEntity>> _loadFromCache() async {
    try {
      final cachedGovernorates = await localDataSource.getCachedGovernorates();

      if (cachedGovernorates.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد محافظات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // Create a response with cached data
      final response = GovernoratesResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        governorates: cachedGovernorates,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
