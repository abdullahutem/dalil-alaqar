import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/datasources/neighborhoods_local_data_source.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/datasources/neighborhoods_remote_data_source.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/models/neighborhood_model.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/models/neighborhoods_response_model.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/repositories/neighborhoods_repository.dart';

class NeighborhoodsRepositoryImpl implements NeighborhoodsRepository {
  final NeighborhoodsRemoteDataSource remoteDataSource;
  final NeighborhoodsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  NeighborhoodsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, NeighborhoodsResponseEntity>>
  getNeighborhoodsByDistrict(int districtId) async {
    final cachedData = _cacheManager.getCachedNeighborhoodsData(districtId);

    if (cachedData != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final neighborhoodsResponse = NeighborhoodsResponseModel.fromJson(
          jsonData,
        );

        _updateCacheInBackground(districtId);

        return Right(neighborhoodsResponse);
      } catch (e) {
        print('Error parsing cached neighborhoods data: $e');
      }
    }

    if (await networkInfo.isConnected ?? false) {
      try {
        final NeighborhoodsResponseModel response = await remoteDataSource
            .getNeighborhoodsByDistrict(districtId);

        final neighborhoods = response.neighborhoods
            .whereType<NeighborhoodModel>()
            .toList();
        await localDataSource.cacheNeighborhoodsByDistrict(
          districtId,
          neighborhoods,
        );

        final jsonData = response.toJson();
        await _cacheManager.cacheNeighborhoodsData(
          districtId,
          json.encode(jsonData),
        );

        return Right(response);
      } on ServerException catch (e) {
        print('ServerException: $e');
        return await _loadFromCache(districtId);
      } on DioException catch (e) {
        print('DioException: $e');
        return await _loadFromCache(districtId);
      } catch (e, stackTrace) {
        print('Error fetching neighborhoods: $e');
        print('Stack trace: $stackTrace');
        return await _loadFromCache(districtId);
      }
    } else {
      return await _loadFromCache(districtId);
    }
  }

  Future<void> _updateCacheInBackground(int districtId) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final NeighborhoodsResponseModel response = await remoteDataSource
            .getNeighborhoodsByDistrict(districtId);

        final neighborhoods = response.neighborhoods
            .whereType<NeighborhoodModel>()
            .toList();
        await localDataSource.cacheNeighborhoodsByDistrict(
          districtId,
          neighborhoods,
        );

        final jsonData = response.toJson();
        await _cacheManager.cacheNeighborhoodsData(
          districtId,
          json.encode(jsonData),
        );
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, NeighborhoodsResponseEntity>> _loadFromCache(
    int districtId,
  ) async {
    try {
      final cachedNeighborhoods = await localDataSource
          .getCachedNeighborhoodsByDistrict(districtId);

      if (cachedNeighborhoods.isEmpty) {
        return Left(
          CacheFailure(
            message: 'لا توجد أحياء سكنية محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      final response = NeighborhoodsResponseModel(
        success: true,
        message: 'تم تحميل البيانات من الذاكرة المؤقتة',
        neighborhoods: cachedNeighborhoods,
      );

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
