import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../domain/entities/currencies_response_entity.dart';
import '../../domain/repositories/currencies_repository.dart';
import '../datasources/currencies_local_data_source.dart';
import '../datasources/currencies_remote_data_source.dart';
import '../models/currencies_response_model.dart';
import '../models/currency_model.dart';

class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesRemoteDataSource remoteDataSource;
  final CurrenciesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  CurrenciesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, CurrenciesResponseEntity>> getCurrencies() async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // العملات نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedCurrenciesData();

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائنات
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final currenciesResponse = CurrenciesResponseModel.fromJson(jsonData);

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground();

        return Right(currenciesResponse);
      } catch (e) {
        print('Error parsing cached currencies data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final CurrenciesResponseModel result = await remoteDataSource
            .getCurrencies();

        // Cache the currencies locally in SQLite
        final currencies = result.currencies
            .whereType<CurrencyModel>()
            .toList();
        await localDataSource.cacheCurrencies(currencies);

        // Cache in SharedPreferences for faster access
        final jsonData = result.toJson();
        await _cacheManager.cacheCurrenciesData(json.encode(jsonData));

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
        print('Error fetching currencies: $e');
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
        final CurrenciesResponseModel result = await remoteDataSource
            .getCurrencies();

        final currencies = result.currencies
            .whereType<CurrencyModel>()
            .toList();
        await localDataSource.cacheCurrencies(currencies);

        final jsonData = result.toJson();
        await _cacheManager.cacheCurrenciesData(json.encode(jsonData));
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, CurrenciesResponseEntity>> _loadFromCache() async {
    try {
      final cachedCurrencies = await localDataSource.getCachedCurrencies();

      if (cachedCurrencies.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد عملات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      // Create a response with cached data
      final response = CurrenciesResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        currencies: cachedCurrencies,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
