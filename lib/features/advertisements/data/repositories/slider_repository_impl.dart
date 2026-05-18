import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/advertisements/data/datasources/slider_local_data_source.dart';
import 'package:dalil_alaqar/features/advertisements/data/datasources/slider_remote_data_source.dart';
import 'package:dalil_alaqar/features/advertisements/data/models/slide_model.dart';
import 'package:dalil_alaqar/features/advertisements/data/models/slider_response_model.dart';
import 'package:dalil_alaqar/features/advertisements/domain/entities/slider_response_entity.dart';
import 'package:dalil_alaqar/features/advertisements/domain/repositories/slider_repository.dart';
import 'dart:convert';

class SliderRepositoryImpl implements SliderRepository {
  final SliderRemoteDataSource remoteDataSource;
  final SliderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  SliderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, SliderResponseEntity>> getSlides() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // هذا يحسن الأداء بشكل كبير لأن البيانات غير مهمة ولا تتغير كثيراً
    final cachedData = _cacheManager.getCachedSliderData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final List<dynamic> slidesJson = jsonData['slides'] as List;
        final slides = slidesJson
            .map((json) => SlideModel.fromJson(json as Map<String, dynamic>))
            .toList();

        final response = SliderResponseModel(
          slides: slides,
          count: slides.length,
        );

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(response);
      } catch (e) {
        print('Error parsing cached slider data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected!) {
      try {
        // Fetch fresh data from API
        final result = await remoteDataSource.getSlides();

        // Cache the slides locally in SQLite
        final slides = result.slides
            .map((slide) => slide as SlideModel)
            .toList();
        await localDataSource.cacheSlides(slides);

        // Cache in SharedPreferences for faster access
        final jsonData = {
          'slides': slides.map((s) => s.toJson()).toList(),
          'count': slides.length,
        };
        await _cacheManager.cacheSliderData(json.encode(jsonData));

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
        print('Error fetching slides: $e');
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
      if (await networkInfo.isConnected!) {
        final result = await remoteDataSource.getSlides();

        final slides = result.slides
            .map((slide) => slide as SlideModel)
            .toList();
        await localDataSource.cacheSlides(slides);

        final jsonData = {
          'slides': slides.map((s) => s.toJson()).toList(),
          'count': slides.length,
        };
        await _cacheManager.cacheSliderData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, SliderResponseEntity>> _loadFromCache() async {
    try {
      final cachedSlides = await localDataSource.getCachedSlides();

      if (cachedSlides.isEmpty) {
        return Left(
          CacheFailure(
            message:
                'No cached data available. Please connect to the internet.',
          ),
        );
      }

      final response = SliderResponseModel(
        slides: cachedSlides,
        count: cachedSlides.length,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'Failed to load cached data: ${e.toString()}'),
      );
    }
  }
}
