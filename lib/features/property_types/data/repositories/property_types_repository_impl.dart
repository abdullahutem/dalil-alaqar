import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_local_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/models/property_type_model.dart';
import 'package:dalil_alaqar/features/property_types/data/models/property_types_response_model.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';

class PropertyTypesRepositoryImpl implements PropertyTypesRepository {
  final PropertyTypesRemoteDataSource remoteDataSource;
  final PropertyTypesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  PropertyTypesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, PropertyTypesResponseEntity>>
  getPropertyTypes() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // أنواع العقارات نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedPropertyTypesData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final propertyTypesResponse = PropertyTypesResponseModel.fromJson(
          jsonData,
        );

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(propertyTypesResponse);
      } catch (e) {
        print('Error parsing cached property types data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final result = await remoteDataSource.getPropertyTypes();

        // Cache the property types locally in SQLite
        final propertyTypes = result.propertyTypes
            .map((type) => type as PropertyTypeModel)
            .toList();
        await localDataSource.cachePropertyTypes(propertyTypes);

        // Cache in SharedPreferences for faster access
        final jsonData = result.toJson();
        await _cacheManager.cachePropertyTypesData(json.encode(jsonData));

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
        print('Error fetching property types: $e');
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
        final result = await remoteDataSource.getPropertyTypes();

        final propertyTypes = result.propertyTypes
            .map((type) => type as PropertyTypeModel)
            .toList();
        await localDataSource.cachePropertyTypes(propertyTypes);

        final jsonData = result.toJson();
        await _cacheManager.cachePropertyTypesData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, PropertyTypesResponseEntity>> _loadFromCache() async {
    try {
      final cachedPropertyTypes = await localDataSource
          .getCachedPropertyTypes();

      if (cachedPropertyTypes.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد بيانات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // Create a response with cached data
      final response = PropertyTypesResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        propertyTypes: cachedPropertyTypes,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
