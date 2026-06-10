import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offices/data/datasources/offices_local_data_source.dart';
import 'package:dalil_alaqar/features/offices/data/datasources/offices_remote_data_source.dart';
import 'package:dalil_alaqar/features/offices/data/models/office_model.dart';
import 'package:dalil_alaqar/features/offices/data/models/offices_response_model.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/offices_response_entity.dart';
import 'package:dalil_alaqar/features/offices/domain/repositories/offices_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class OfficesRepositoryImpl implements OfficesRepository {
  final OfficesRemoteDataSource remoteDataSource;
  final OfficesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  OfficesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, OfficesResponseEntity>> getOffices({
    required int page,
    required int perPage,
  }) async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // هذا يحسن الأداء بشكل كبير خاصة للصفحة الأولى
    if (page == 1) {
      final cachedData = _cacheManager.getCachedOfficesData();

      if (cachedData != null) {
        try {
          // تحويل البيانات المخزنة إلى كائنات
          final Map<String, dynamic> jsonData = json.decode(cachedData);
          final officesResponse = OfficesResponseModel.fromJson(jsonData);

          // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
          _updateCacheInBackground(page: page, perPage: perPage);

          return Right(officesResponse);
        } catch (e) {
          print('Error parsing cached offices data: $e');
          // في حالة فشل تحليل البيانات، نحاول التحميل من API
        }
      }
    }

    // ثانياً: إذا لم يكن هناك كاش أو الصفحة ليست الأولى، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final result = await remoteDataSource.getOffices(
          page: page,
          perPage: perPage,
        );

        // Cache only the first page
        if (page == 1) {
          // Cache the offices locally in SQLite
          final offices = result.data
              .map((office) => office as OfficeModel)
              .toList();
          await localDataSource.cacheOffices(offices);

          // Cache in SharedPreferences for faster access
          final jsonData = result.toJson();
          await _cacheManager.cacheOfficesData(json.encode(jsonData));
        }

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        // If API fails and it's the first page, try to load from cache
        if (page == 1) {
          return await _loadFromCache();
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } on DioException catch (e) {
        print('DioException: $e');
        // If network error occurs and it's the first page, try to load from cache
        if (page == 1) {
          return await _loadFromCache();
        }
        return Left(Failure(errMessage: 'خطأ في الاتصال بالإنترنت'));
      } catch (e, stackTrace) {
        // If any other error occurs, log it and try to load from cache for first page
        print('Error fetching offices: $e');
        print('Stack trace: $stackTrace');
        if (page == 1) {
          return await _loadFromCache();
        }
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      // No internet connection
      if (page == 1) {
        // Load from cache for first page
        return await _loadFromCache();
      }
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  /// تحديث الكاش في الخلفية دون انتظار
  Future<void> _updateCacheInBackground({
    required int page,
    required int perPage,
  }) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final result = await remoteDataSource.getOffices(
          page: page,
          perPage: perPage,
        );

        final offices = result.data
            .map((office) => office as OfficeModel)
            .toList();
        await localDataSource.cacheOffices(offices);

        final jsonData = result.toJson();
        await _cacheManager.cacheOfficesData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, OfficesResponseEntity>> _loadFromCache() async {
    try {
      final cachedOffices = await localDataSource.getCachedOffices();

      if (cachedOffices.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد بيانات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // Create a response with cached data
      // Note: We can't get exact pagination info from cache, so we use defaults
      final response = OfficesResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        data: cachedOffices,
        meta: MetaModel(
          currentPage: 1,
          perPage: cachedOffices.length,
          total: cachedOffices.length,
          lastPage: 1,
        ),
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
