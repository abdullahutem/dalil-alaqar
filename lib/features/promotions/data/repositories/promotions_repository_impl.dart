import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/promotions/data/datasources/promotions_local_data_source.dart';
import 'package:dalil_alaqar/features/promotions/data/datasources/promotions_remote_data_source.dart';
import 'package:dalil_alaqar/features/promotions/data/models/promotion_model.dart';
import 'package:dalil_alaqar/features/promotions/data/models/promotions_response_model.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotions_response_entity.dart';
import 'package:dalil_alaqar/features/promotions/domain/repositories/promotions_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource remoteDataSource;
  final PromotionsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  PromotionsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, PromotionsResponseEntity>> getPromotions() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // العروض الترويجية نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedPromotionsData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final promotionsResponse = PromotionsResponseModel.fromJson(jsonData);

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(promotionsResponse);
      } catch (e) {
        print('Error parsing cached promotions data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final PromotionsResponseModel result = await remoteDataSource
            .getPromotions();

        // Cache the promotions locally in SQLite
        final promotions = result.data.whereType<PromotionModel>().toList();
        await localDataSource.cachePromotions(promotions);

        // Cache in SharedPreferences for faster access
        final jsonData = result.toJson();
        await _cacheManager.cachePromotionsData(json.encode(jsonData));

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
        print('Error fetching promotions: $e');
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
        final PromotionsResponseModel result = await remoteDataSource
            .getPromotions();

        final promotions = result.data.whereType<PromotionModel>().toList();
        await localDataSource.cachePromotions(promotions);

        final jsonData = result.toJson();
        await _cacheManager.cachePromotionsData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, PromotionsResponseEntity>> _loadFromCache() async {
    try {
      final cachedPromotions = await localDataSource.getCachedPromotions();

      if (cachedPromotions.isEmpty) {
        return Left(
          CacheFailure(message: 'لا توجد عروض محفوظة. يرجى الاتصال بالإنترنت.'),
        );
      }

      // Create a response with cached data
      final response = PromotionsResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        data: cachedPromotions,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
