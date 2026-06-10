import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_local_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/property_details_local_data_source.dart';
import 'package:dalil_alaqar/features/properties/data/models/properties_response_model.dart';
import 'package:dalil_alaqar/features/properties/data/models/property_details_model.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/repositories/properties_repository.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesRemoteDataSource remoteDataSource;
  final PropertiesLocalDataSource localDataSource;
  final PropertyDetailsLocalDataSource propertyDetailsLocalDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  PropertiesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.propertyDetailsLocalDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, PropertiesResponseEntity>> getProperties({
    int page = 1,
    int perPage = 20,
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
      final cachedData = _cacheManager.getCachedPropertiesData();

      if (cachedData != null) {
        try {
          final Map<String, dynamic> jsonData = json.decode(cachedData);
          final propertiesResponse = PropertiesResponseModel.fromJson(jsonData);

          // Update cache in background
          _updateCacheInBackground(page: page, perPage: perPage);

          return Right(propertiesResponse);
        } catch (e) {
          print('Error parsing cached properties data: $e');
        }
      }
    }

    // Fetch from API
    if (await networkInfo.isConnected ?? false) {
      try {
        final result = await remoteDataSource.getProperties(
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
          final jsonData = result.toJson();
          final jsonString = json.encode(jsonData);

          await localDataSource.cachePropertiesJson(jsonString);
          await _cacheManager.cachePropertiesData(jsonString);
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
        print('Error fetching properties: $e');
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
        final result = await remoteDataSource.getProperties(
          page: page,
          perPage: perPage,
        );

        final jsonData = result.toJson();
        final jsonString = json.encode(jsonData);

        await localDataSource.cachePropertiesJson(jsonString);
        await _cacheManager.cachePropertiesData(jsonString);
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, PropertiesResponseEntity>> _loadFromCache() async {
    try {
      final cachedJson = await localDataSource.getCachedPropertiesJson();

      if (cachedJson == null) {
        return Left(
          CacheFailure(
            message: 'لا توجد بيانات محفوظة. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      final Map<String, dynamic> jsonData = json.decode(cachedJson);
      final response = PropertiesResponseModel.fromJson(jsonData);

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsEntity>> getPropertyDetails({
    required int id,
  }) async {
    // Try cache first
    final cachedData = _cacheManager.getCachedPropertyDetailsData(id);

    if (cachedData != null) {
      try {
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final propertyDetails = PropertyDetailsModel.fromJson(jsonData);

        // Update cache in background
        _updatePropertyDetailsCacheInBackground(id);

        return Right(propertyDetails);
      } catch (e) {
        print('Error parsing cached property details data: $e');
      }
    }

    // Fetch from API
    if (await networkInfo.isConnected ?? false) {
      try {
        final result = await remoteDataSource.getPropertyDetails(id: id);

        // Cache the property details
        final jsonData = _propertyDetailsToJson(result);
        final jsonString = json.encode(jsonData);

        await propertyDetailsLocalDataSource.cachePropertyDetails(
          id,
          jsonString,
        );
        await _cacheManager.cachePropertyDetailsData(id, jsonString);

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        return await _loadPropertyDetailsFromCache(id);
      } on DioException catch (e) {
        print('DioException: $e');
        return await _loadPropertyDetailsFromCache(id);
      } catch (e) {
        print('Error fetching property details: $e');
        return await _loadPropertyDetailsFromCache(id);
      }
    } else {
      // No internet connection
      return await _loadPropertyDetailsFromCache(id);
    }
  }

  Future<void> _updatePropertyDetailsCacheInBackground(int propertyId) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final result = await remoteDataSource.getPropertyDetails(
          id: propertyId,
        );

        final jsonData = _propertyDetailsToJson(result);
        final jsonString = json.encode(jsonData);

        await propertyDetailsLocalDataSource.cachePropertyDetails(
          propertyId,
          jsonString,
        );
        await _cacheManager.cachePropertyDetailsData(propertyId, jsonString);
      }
    } catch (e) {
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, PropertyDetailsEntity>> _loadPropertyDetailsFromCache(
    int propertyId,
  ) async {
    try {
      final cachedJson = await propertyDetailsLocalDataSource
          .getCachedPropertyDetails(propertyId);

      if (cachedJson == null) {
        return Left(
          CacheFailure(
            message:
                'لا توجد بيانات محفوظة لهذا العقار. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      final Map<String, dynamic> jsonData = json.decode(cachedJson);
      final response = PropertyDetailsModel.fromJson(jsonData);

      return Right(response);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }

  Map<String, dynamic> _propertyDetailsToJson(PropertyDetailsEntity details) {
    // Convert the entire property details to JSON for caching
    final model = details as PropertyDetailsModel;
    // Since PropertyDetailsModel doesn't have toJson, we construct it manually
    return {
      'id': model.id,
      'office_id': model.officeId,
      'property_type_id': model.propertyTypeId,
      'offer_type_id': model.offerTypeId,
      'title': model.title,
      'description': model.description,
      'reference_number': model.referenceNumber,
      'price': model.price,
      'currency_id': model.currencyId,
      'price_negotiable': model.priceNegotiable,
      'governorate_id': model.governorateId,
      'district_id': model.districtId,
      'neighborhood_id': model.neighborhoodId,
      'address': model.address,
      'latitude': model.latitude,
      'longitude': model.longitude,
      'status': model.status,
      'views_count': model.viewsCount,
      'published_at': model.publishedAt,
      'created_at': model.createdAt,
      'updated_at': model.updatedAt,
      'office': {
        'id': model.office.id,
        'name': model.office.name,
        'slug': model.office.slug,
        'email': model.office.email,
        'phone': model.office.phone,
        'whatsapp_number': model.office.whatsappNumber,
      },
      'property_type': {
        'id': model.propertyType.id,
        'name': model.propertyType.name,
        'icon': model.propertyType.icon,
      },
      'offer_type': {'id': model.offerType.id, 'name': model.offerType.name},
      'governorate': {
        'id': model.governorate.id,
        'name_ar': model.governorate.nameAr,
      },
      'district': {'id': model.district.id, 'name_ar': model.district.nameAr},
      'neighborhood': {
        'id': model.neighborhood.id,
        'name_ar': model.neighborhood.nameAr,
      },
      'currency': model.currency != null
          ? {
              'id': model.currency!.id,
              'name': model.currency!.name,
              'code': model.currency!.code,
              'symbol': model.currency!.symbol,
            }
          : null,
      'images': model.images
          .map(
            (img) => {
              'id': img.id,
              'property_id': img.propertyId,
              'image_path': img.imagePath,
              'is_primary': img.isPrimary,
              'order': img.order,
              'created_at': img.createdAt,
              'updated_at': img.updatedAt,
            },
          )
          .toList(),
      'primary_image': model.primaryImage != null
          ? {
              'id': model.primaryImage!.id,
              'property_id': model.primaryImage!.propertyId,
              'image_path': model.primaryImage!.imagePath,
              'is_primary': model.primaryImage!.isPrimary,
              'order': model.primaryImage!.order,
              'created_at': model.primaryImage!.createdAt,
              'updated_at': model.primaryImage!.updatedAt,
            }
          : null,
    };
  }
}
