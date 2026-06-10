import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_helper.dart';
import 'package:dalil_alaqar/core/databases/cache/cache_manager.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_details/data/datasources/office_details_local_data_source.dart';
import 'package:dalil_alaqar/features/office_details/data/datasources/office_details_remote_data_source.dart';
import 'package:dalil_alaqar/features/office_details/data/models/office_details_model.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/domain/repositories/office_details_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

class OfficeDetailsRepositoryImpl implements OfficeDetailsRepository {
  final OfficeDetailsRemoteDataSource remoteDataSource;
  final OfficeDetailsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  late final CacheManager _cacheManager;

  OfficeDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  }) {
    _cacheManager = CacheManager(CacheHelper.sharedPreferences);
  }

  @override
  Future<Either<Failure, OfficeDetailsEntity>> getOfficeDetails(
    int officeId,
  ) async {
    // أولاً: محاولة تحميل البيانات من الكاش السريع (SharedPreferences)
    // تفاصيل المكتب نادراً ما تتغير، لذا الكاش مفيد جداً
    final cachedData = _cacheManager.getCachedOfficeDetailsData(officeId);

    if (cachedData != null) {
      try {
        // تحويل البيانات المخزنة إلى كائن
        final Map<String, dynamic> jsonData = json.decode(cachedData);
        final officeDetails = OfficeDetailsModel.fromJson(jsonData);

        // تحديث البيانات في الخلفية إذا كان متصل بالإنترنت
        _updateCacheInBackground(officeId);

        return Right(officeDetails);
      } catch (e) {
        print('Error parsing cached office details data: $e');
        // في حالة فشل تحليل البيانات، نحاول التحميل من API
      }
    }

    // ثانياً: إذا لم يكن هناك كاش، نحاول التحميل من API
    if (await networkInfo.isConnected ?? false) {
      try {
        // Fetch fresh data from API
        final result = await remoteDataSource.getOfficeDetails(officeId);

        // Cache the office details locally in SQLite
        await localDataSource.cacheOfficeDetails(officeId, result);

        // Cache in SharedPreferences for faster access
        final jsonData = {
          'id': result.id,
          'name': result.name,
          'owner_name': result.ownerName,
          'slug': result.slug,
          'logo': result.logo,
          'email': result.email,
          'phone': result.phone,
          'mobile_phone': result.mobilePhone,
          'whatsapp_number': result.whatsappNumber,
          'commercial_license': result.commercialLicense,
          'license_number': result.licenseNumber,
          'description': result.description,
          'website': result.website,
          'facebook': result.facebook,
          'instagram': result.instagram,
          'twitter': result.twitter,
          'governorate_id': result.governorateId,
          'district_id': result.districtId,
          'address': result.address,
          'latitude': result.latitude,
          'longitude': result.longitude,
          'subscription_type': result.subscriptionType,
          'subscription_start_date': result.subscriptionStartDate,
          'subscription_end_date': result.subscriptionEndDate,
          'max_properties': result.maxProperties,
          'is_verified': result.isVerified,
          'verification_date': result.verificationDate,
          'rating': result.rating,
          'total_ratings': result.totalRatings,
          'total_properties': result.totalProperties,
          'total_views': result.totalViews,
          'status': result.status,
          'created_at': result.createdAt,
          'updated_at': result.updatedAt,
          'governorate': {
            'id': result.governorate.id,
            'name_ar': result.governorate.nameAr,
          },
          'district': {
            'id': result.district.id,
            'name_ar': result.district.nameAr,
          },
          'recent_properties': result.recentProperties
              .map(
                (prop) => {
                  'id': prop.id,
                  'office_id': prop.officeId,
                  'property_type_id': prop.propertyTypeId,
                  'offer_type_id': prop.offerTypeId,
                  'title': prop.title,
                  'description': prop.description,
                  'reference_number': prop.referenceNumber,
                  'price': prop.price,
                  'price_negotiable': prop.priceNegotiable,
                  'governorate_id': prop.governorateId,
                  'district_id': prop.districtId,
                  'neighborhood_id': prop.neighborhoodId,
                  'address': prop.address,
                  'latitude': prop.latitude,
                  'longitude': prop.longitude,
                  'status': prop.status,
                  'views_count': prop.viewsCount,
                  'published_at': prop.publishedAt,
                  'created_at': prop.createdAt,
                  'updated_at': prop.updatedAt,
                  'property_type': {
                    'id': prop.propertyType.id,
                    'name': prop.propertyType.name,
                  },
                  'offer_type': {
                    'id': prop.offerType.id,
                    'name': prop.offerType.name,
                  },
                  'primary_image': prop.primaryImage,
                },
              )
              .toList(),
        };
        await _cacheManager.cacheOfficeDetailsData(
          officeId,
          json.encode(jsonData),
        );

        return Right(result);
      } on ServerException catch (e) {
        print('ServerException: $e');
        // If API fails, try to load from SQLite cache
        return await _loadFromCache(officeId);
      } on DioException catch (e) {
        print('DioException: $e');
        // If network error occurs, try to load from SQLite cache
        return await _loadFromCache(officeId);
      } catch (e, stackTrace) {
        // If any other error occurs, log it and try to load from SQLite cache
        print('Error fetching office details: $e');
        print('Stack trace: $stackTrace');
        return await _loadFromCache(officeId);
      }
    } else {
      // No internet connection, load from SQLite cache
      return await _loadFromCache(officeId);
    }
  }

  /// تحديث الكاش في الخلفية دون انتظار
  Future<void> _updateCacheInBackground(int officeId) async {
    try {
      if (await networkInfo.isConnected ?? false) {
        final result = await remoteDataSource.getOfficeDetails(officeId);

        await localDataSource.cacheOfficeDetails(officeId, result);

        final jsonData = {
          'id': result.id,
          'name': result.name,
          'owner_name': result.ownerName,
          'slug': result.slug,
          'logo': result.logo,
          'email': result.email,
          'phone': result.phone,
          'mobile_phone': result.mobilePhone,
          'whatsapp_number': result.whatsappNumber,
          'commercial_license': result.commercialLicense,
          'license_number': result.licenseNumber,
          'description': result.description,
          'website': result.website,
          'facebook': result.facebook,
          'instagram': result.instagram,
          'twitter': result.twitter,
          'governorate_id': result.governorateId,
          'district_id': result.districtId,
          'address': result.address,
          'latitude': result.latitude,
          'longitude': result.longitude,
          'subscription_type': result.subscriptionType,
          'subscription_start_date': result.subscriptionStartDate,
          'subscription_end_date': result.subscriptionEndDate,
          'max_properties': result.maxProperties,
          'is_verified': result.isVerified,
          'verification_date': result.verificationDate,
          'rating': result.rating,
          'total_ratings': result.totalRatings,
          'total_properties': result.totalProperties,
          'total_views': result.totalViews,
          'status': result.status,
          'created_at': result.createdAt,
          'updated_at': result.updatedAt,
          'governorate': {
            'id': result.governorate.id,
            'name_ar': result.governorate.nameAr,
          },
          'district': {
            'id': result.district.id,
            'name_ar': result.district.nameAr,
          },
          'recent_properties': result.recentProperties
              .map(
                (prop) => {
                  'id': prop.id,
                  'office_id': prop.officeId,
                  'property_type_id': prop.propertyTypeId,
                  'offer_type_id': prop.offerTypeId,
                  'title': prop.title,
                  'description': prop.description,
                  'reference_number': prop.referenceNumber,
                  'price': prop.price,
                  'price_negotiable': prop.priceNegotiable,
                  'governorate_id': prop.governorateId,
                  'district_id': prop.districtId,
                  'neighborhood_id': prop.neighborhoodId,
                  'address': prop.address,
                  'latitude': prop.latitude,
                  'longitude': prop.longitude,
                  'status': prop.status,
                  'views_count': prop.viewsCount,
                  'published_at': prop.publishedAt,
                  'created_at': prop.createdAt,
                  'updated_at': prop.updatedAt,
                  'property_type': {
                    'id': prop.propertyType.id,
                    'name': prop.propertyType.name,
                  },
                  'offer_type': {
                    'id': prop.offerType.id,
                    'name': prop.offerType.name,
                  },
                  'primary_image': prop.primaryImage,
                },
              )
              .toList(),
        };
        await _cacheManager.cacheOfficeDetailsData(
          officeId,
          json.encode(jsonData),
        );
      }
    } catch (e) {
      // تجاهل الأخطاء في التحديث الخلفي
      print('Background cache update failed: $e');
    }
  }

  Future<Either<Failure, OfficeDetailsEntity>> _loadFromCache(
    int officeId,
  ) async {
    try {
      final cachedDetails = await localDataSource.getCachedOfficeDetails(
        officeId,
      );

      if (cachedDetails == null) {
        return Left(
          CacheFailure(
            message:
                'لا توجد بيانات محفوظة لهذا المكتب. يرجى الاتصال بالإنترنت.',
          ),
        );
      }

      return Right(cachedDetails);
    } catch (e) {
      return Left(
        CacheFailure(message: 'فشل تحميل البيانات المحفوظة: ${e.toString()}'),
      );
    }
  }
}
