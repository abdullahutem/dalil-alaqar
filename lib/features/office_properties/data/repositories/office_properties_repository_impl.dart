import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/create_property_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/property_details_response_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/upload_images_response_entity.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/update_property_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../data/models/create_property_model.dart';
import '../../data/models/office_properties_response_model.dart';
import '../../data/models/property_details_response_model.dart';
import '../../data/models/update_property_model.dart';
import '../../domain/entities/office_properties_response_entity.dart';
import '../../domain/entities/property_stats_entity.dart';
import '../../domain/repositories/office_properties_repository.dart';
import '../datasources/office_properties_list_local_data_source.dart';
import '../datasources/office_properties_remote_data_source.dart';
import '../datasources/office_property_details_local_data_source.dart';

class OfficePropertiesRepositoryImpl implements OfficePropertiesRepository {
  final OfficePropertiesRemoteDataSource remoteDataSource;
  final OfficePropertiesListLocalDataSource listLocalDataSource;
  final OfficePropertyDetailsLocalDataSource detailsLocalDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  OfficePropertiesRepositoryImpl({
    required this.remoteDataSource,
    required this.listLocalDataSource,
    required this.detailsLocalDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }
  @override
  Future<Either<Failure, OfficePropertiesResponseEntity>> getOfficeProperties({
    required int page,
    required int perPage,
    String? search,
    int? propertyTypeId,
    int? offerTypeId,
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
    double? minPrice,
    double? maxPrice,
  }) async {
    // Only cache the first page without filters
    final bool isFirstPageNoFilters =
        page == 1 &&
        search == null &&
        propertyTypeId == null &&
        offerTypeId == null &&
        governorateId == null &&
        districtId == null &&
        neighborhoodId == null &&
        minPrice == null &&
        maxPrice == null;

    // Try cache only for first page without filters
    if (isFirstPageNoFilters) {
      final cachedData = _cacheManager.getCachedOfficePropertiesListData();

      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = json.decode(cachedData);
          final propertiesResponse = OfficePropertiesResponseModel.fromJson(
            jsonData,
          );

          // Update cache in background
          _updateCacheInBackground(page: page, perPage: perPage);

          return Right(propertiesResponse);
        } catch (e) {
          print('Error parsing cached office properties data: $e');
        }
      }
    }

    // Fetch from API
    if (await networkInfo.isConnected ?? false) {
      try {
        final result = await remoteDataSource.getOfficeProperties(
          page: page,
          perPage: perPage,
          search: search,
          propertyTypeId: propertyTypeId,
          offerTypeId: offerTypeId,
          governorateId: governorateId,
          districtId: districtId,
          neighborhoodId: neighborhoodId,
          minPrice: minPrice,
          maxPrice: maxPrice,
        );

        // Cache only first page without filters
        if (isFirstPageNoFilters) {
          final jsonData = (result as OfficePropertiesResponseModel).toJson();
          final jsonString = json.encode(jsonData);

          await listLocalDataSource.cacheOfficePropertiesJson(jsonString);
          await _cacheManager.cacheOfficePropertiesListData(jsonString);
        }

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        if (isFirstPageNoFilters) {
          return await _loadFromCache();
        }
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } on DioException catch (e) {
        print('DioException: $e');
        if (isFirstPageNoFilters) {
          return await _loadFromCache();
        }
        return Left(
          ServerFailure(errMessage: e.message ?? 'Network error occurred'),
        );
      } catch (e) {
        print('Error fetching office properties: $e');
        if (isFirstPageNoFilters) {
          return await _loadFromCache();
        }
        return Left(
          ServerFailure(errMessage: 'Unexpected error: ${e.toString()}'),
        );
      }
    } else {
      // No internet - try cache for first page
      if (isFirstPageNoFilters) {
        return await _loadFromCache();
      }
      return Left(
        ServerFailure(
          errMessage: 'No internet connection. Please check your network.',
        ),
      );
    }
  }

  Future<void> _updateCacheInBackground({
    required int page,
    required int perPage,
  }) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final result = await remoteDataSource.getOfficeProperties(
          page: page,
          perPage: perPage,
        );

        final jsonData = (result as OfficePropertiesResponseModel).toJson();
        final jsonString = json.encode(jsonData);

        await listLocalDataSource.cacheOfficePropertiesJson(jsonString);
        await _cacheManager.cacheOfficePropertiesListData(jsonString);
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, OfficePropertiesResponseEntity>>
  _loadFromCache() async {
    try {
      final cachedJson = await listLocalDataSource
          .getCachedOfficePropertiesJson();

      if (cachedJson == null) {
        return Left(
          CacheFailure(
            message: 'لا توجد بيانات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      final Map<String, dynamic> jsonData = json.decode(cachedJson);
      final response = OfficePropertiesResponseModel.fromJson(jsonData);

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, PropertyStatsEntity>> getPropertyStats() async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getPropertyStats();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProperty(int propertyId) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final message = await remoteDataSource.deleteProperty(propertyId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsResponseEntity>> getPropertyDetails({
    required int propertyId,
  }) async {
    // Try cache first
    final cachedData = _cacheManager.getCachedOfficePropertyDetailsData(
      propertyId,
    );

    if (cachedData != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final propertyDetails = PropertyDetailsResponseModel.fromJson(jsonData);

        // Update cache in background
        _updatePropertyDetailsCacheInBackground(propertyId);

        return Right(propertyDetails);
      } catch (e) {
        print('Error parsing cached office property details data: $e');
      }
    }

    // Fetch from API
    if (await networkInfo.isConnected ?? false) {
      try {
        final result = await remoteDataSource.getPropertyDetails(
          propertyId: propertyId,
        );

        // Cache the property details
        final jsonData = (result as PropertyDetailsResponseModel).toJson();
        final jsonString = json.encode(jsonData);

        await detailsLocalDataSource.cachePropertyDetails(
          propertyId,
          jsonString,
        );
        await _cacheManager.cacheOfficePropertyDetailsData(
          propertyId,
          jsonString,
        );

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        return await _loadPropertyDetailsFromCache(propertyId);
      } on DioException catch (e) {
        print('DioException: $e');
        return await _loadPropertyDetailsFromCache(propertyId);
      } catch (e) {
        print('Error fetching office property details: $e');
        return await _loadPropertyDetailsFromCache(propertyId);
      }
    } else {
      // No internet connection
      return await _loadPropertyDetailsFromCache(propertyId);
    }
  }

  Future<void> _updatePropertyDetailsCacheInBackground(int propertyId) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final result = await remoteDataSource.getPropertyDetails(
          propertyId: propertyId,
        );

        final jsonData = (result as PropertyDetailsResponseModel).toJson();
        final jsonString = json.encode(jsonData);

        await detailsLocalDataSource.cachePropertyDetails(
          propertyId,
          jsonString,
        );
        await _cacheManager.cacheOfficePropertyDetailsData(
          propertyId,
          jsonString,
        );
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, PropertyDetailsResponseEntity>>
  _loadPropertyDetailsFromCache(int propertyId) async {
    try {
      final cachedJson = await detailsLocalDataSource.getCachedPropertyDetails(
        propertyId,
      );

      if (cachedJson == null) {
        return Left(
          CacheFailure(
            message:
                'لا توجد بيانات محفوظة لهذا العقار. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      final Map<String, dynamic> jsonData = json.decode(cachedJson);
      final response = PropertyDetailsResponseModel.fromJson(jsonData);

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsResponseEntity>> updatePropertyStatus({
    required int propertyId,
    required String status,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.updatePropertyStatus(
        propertyId: propertyId,
        status: status,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, UploadImagesResponseEntity>> uploadPropertyImages({
    required int propertyId,
    required List<String> imagePaths,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.uploadPropertyImages(
        propertyId: propertyId,
        imagePaths: imagePaths,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> setPrimaryImage({
    required int propertyId,
    required int imageId,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final message = await remoteDataSource.setPrimaryImage(
        propertyId: propertyId,
        imageId: imageId,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deletePropertyImage({
    required int propertyId,
    required int imageId,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final message = await remoteDataSource.deletePropertyImage(
        propertyId: propertyId,
        imageId: imageId,
      );
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsResponseEntity>> createProperty({
    required CreatePropertyEntity property,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final propertyModel = CreatePropertyModel.fromEntity(property);
      final result = await remoteDataSource.createProperty(
        property: propertyModel,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsResponseEntity>> updateProperty({
    required UpdatePropertyEntity property,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final propertyModel = UpdatePropertyModel.fromEntity(property);
      final result = await remoteDataSource.updateProperty(
        propertyId: property.propertyId,
        data: propertyModel.toJson(),
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
