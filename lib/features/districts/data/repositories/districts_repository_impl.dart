import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_local_data_source.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_remote_data_source.dart';
import 'package:dalil_alaqar/features/districts/data/models/district_model.dart';
import 'package:dalil_alaqar/features/districts/data/models/districts_response_model.dart';
import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';
import 'package:dalil_alaqar/features/districts/domain/repositories/districts_repository.dart';

class DistrictsRepositoryImpl implements DistrictsRepository {
  final DistrictsRemoteDataSource remoteDataSource;
  final DistrictsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  DistrictsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, DistrictsResponseEntity>> getDistrictsByGovernorate(
    int governorateId,
  ) async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // الأحياء نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedDistrictsData(governorateId);

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final districtsResponse = DistrictsResponseModel.fromJson(jsonData);

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground(governorateId);

        return Right(districtsResponse);
      } catch (e) {
        print('Error parsing cached districts data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final DistrictsResponseModel response = await remoteDataSource
            .getDistrictsByGovernorate(governorateId);

        // Cache the districts locally in SQLite
        final districts = response.districts
            .whereType<DistrictModel>()
            .toList();
        await localDataSource.cacheDistrictsByGovernorate(
          governorateId,
          districts,
        );

        // Cache in SharedPreferences for faster access
        final jsonData = response.toJson();
        await _cacheManager.cacheDistrictsData(
          governorateId,
          json.encode(jsonData),
        );

        return Right(response);
      } on ServerException catch (e) {
        print('ServerException: $e');
        // If API fails, try to load from SQLite cache
        return await _loadFromCache(governorateId);
      } on DioException catch (e) {
        print('DioException: $e');
        // If network error occurs, try to load from SQLite cache
        return await _loadFromCache(governorateId);
      } catch (e, stackTrace) {
        // If any other error occurs, log it and try to load from SQLite cache
        print('Error fetching districts: $e');
        print('Stack trace: $stackTrace');
        return await _loadFromCache(governorateId);
      }
    } else {
      // No internet connection, load from SQLite cache
      return await _loadFromCache(governorateId);
    }
  }

  /// تحديث الكاش في الخلفية دون انتظار
  Future<void> _updateCacheInBackground(int governorateId) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final DistrictsResponseModel response = await remoteDataSource
            .getDistrictsByGovernorate(governorateId);

        final districts = response.districts
            .whereType<DistrictModel>()
            .toList();
        await localDataSource.cacheDistrictsByGovernorate(
          governorateId,
          districts,
        );

        final jsonData = response.toJson();
        await _cacheManager.cacheDistrictsData(
          governorateId,
          json.encode(jsonData),
        );
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, DistrictsResponseEntity>> _loadFromCache(
    int governorateId,
  ) async {
    try {
      final cachedDistricts = await localDataSource
          .getCachedDistrictsByGovernorate(governorateId);

      if (cachedDistricts.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد أحياء محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // Create a response with cached data
      final response = DistrictsResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        districts: cachedDistricts,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
