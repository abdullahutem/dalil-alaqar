import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/office_details/data/models/office_details_model.dart';
import 'dart:convert';

abstract class OfficeDetailsLocalDataSource {
  Future<OfficeDetailsModel?> getCachedOfficeDetails(int officeId);
  Future<void> cacheOfficeDetails(int officeId, OfficeDetailsModel details);
  Future<void> clearOfficeDetails(int officeId);
  Future<void> clearAllOfficeDetails();
}

class OfficeDetailsLocalDataSourceImpl implements OfficeDetailsLocalDataSource {
  final DatabaseHelper databaseHelper;

  OfficeDetailsLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<OfficeDetailsModel?> getCachedOfficeDetails(int officeId) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      'office_details',
      where: 'office_id = ?',
      whereArgs: [officeId],
    );

    if (result.isEmpty) {
      return null;
    }

    final json = result.first;

    // Parse the main office details
    final detailsJson =
        jsonDecode(json['details_json'] as String) as Map<String, dynamic>;

    return OfficeDetailsModel.fromJson(detailsJson);
  }

  @override
  Future<void> cacheOfficeDetails(
    int officeId,
    OfficeDetailsModel details,
  ) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching office details for office ID: $officeId');

      // Convert the full model to JSON for storage
      final detailsJson = {
        'id': details.id,
        'name': details.name,
        'owner_name': details.ownerName,
        'slug': details.slug,
        'logo': details.logo,
        'email': details.email,
        'phone': details.phone,
        'mobile_phone': details.mobilePhone,
        'whatsapp_number': details.whatsappNumber,
        'commercial_license': details.commercialLicense,
        'license_number': details.licenseNumber,
        'description': details.description,
        'website': details.website,
        'facebook': details.facebook,
        'instagram': details.instagram,
        'twitter': details.twitter,
        'governorate_id': details.governorateId,
        'district_id': details.districtId,
        'address': details.address,
        'latitude': details.latitude,
        'longitude': details.longitude,
        'subscription_type': details.subscriptionType,
        'subscription_start_date': details.subscriptionStartDate,
        'subscription_end_date': details.subscriptionEndDate,
        'max_properties': details.maxProperties,
        'is_verified': details.isVerified,
        'verification_date': details.verificationDate,
        'rating': details.rating,
        'total_ratings': details.totalRatings,
        'total_properties': details.totalProperties,
        'total_views': details.totalViews,
        'status': details.status,
        'created_at': details.createdAt,
        'updated_at': details.updatedAt,
        'governorate': {
          'id': details.governorate.id,
          'name_ar': details.governorate.nameAr,
        },
        'district': {
          'id': details.district.id,
          'name_ar': details.district.nameAr,
        },
        'recent_properties': details.recentProperties
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

      final cachedAt = DateTime.now().toIso8601String();

      // Delete existing cache for this office
      await db.delete(
        'office_details',
        where: 'office_id = ?',
        whereArgs: [officeId],
      );

      // Insert new cache
      await db.insert('office_details', {
        'office_id': officeId,
        'details_json': jsonEncode(detailsJson),
        'cached_at': cachedAt,
      });

      print('✅ Successfully cached office details for office ID: $officeId');
    } catch (e, stackTrace) {
      print('❌ Error caching office details: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearOfficeDetails(int officeId) async {
    final db = await databaseHelper.database;
    await db.delete(
      'office_details',
      where: 'office_id = ?',
      whereArgs: [officeId],
    );
  }

  @override
  Future<void> clearAllOfficeDetails() async {
    final db = await databaseHelper.database;
    await db.delete('office_details');
  }
}
