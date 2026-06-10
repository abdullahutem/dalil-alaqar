import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/offices/data/models/office_model.dart';

abstract class OfficesLocalDataSource {
  Future<List<OfficeModel>> getCachedOffices();
  Future<void> cacheOffices(List<OfficeModel> offices);
  Future<void> clearOffices();
}

class OfficesLocalDataSourceImpl implements OfficesLocalDataSource {
  final DatabaseHelper databaseHelper;

  OfficesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<OfficeModel>> getCachedOffices() async {
    final db = await databaseHelper.database;
    final result = await db.query('offices', orderBy: 'id ASC');

    return result.map((json) {
      return OfficeModel(
        id: json['id'] as int,
        name: json['name'] as String,
        ownerName: json['owner_name'] as String?,
        slug: json['slug'] as String,
        logo: json['logo'] as String?,
        email: json['email'] as String?,
        phone: json['phone'] as String?,
        mobilePhone: json['mobile_phone'] as String?,
        whatsappNumber: json['whatsapp_number'] as String?,
        commercialLicense: json['commercial_license'] as String?,
        licenseNumber: json['license_number'] as String?,
        description: json['description'] as String?,
        website: json['website'] as String?,
        facebook: json['facebook'] as String?,
        instagram: json['instagram'] as String?,
        twitter: json['twitter'] as String?,
        governorateId: json['governorate_id'] as int?,
        districtId: json['district_id'] as int?,
        address: json['address'] as String?,
        latitude: json['latitude'] as String?,
        longitude: json['longitude'] as String?,
        subscriptionType: json['subscription_type'] as String?,
        subscriptionStartDate: json['subscription_start_date'] as String?,
        subscriptionEndDate: json['subscription_end_date'] as String?,
        maxProperties: json['max_properties'] as int?,
        isVerified: (json['is_verified'] as int) == 1,
        verificationDate: json['verification_date'] as String?,
        rating: json['rating'] != null
            ? double.tryParse(json['rating'].toString())
            : null,
        totalRatings: json['total_ratings'] as int?,
        totalProperties: json['total_properties'] as int?,
        totalViews: json['total_views'] as int?,
        status: json['status'] as String?,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        // Note: governorate and district nested objects are not stored in cache
        // They can be fetched from their respective tables if needed
      );
    }).toList();
  }

  @override
  Future<void> cacheOffices(List<OfficeModel> offices) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${offices.length} offices to database');

      // Clear existing offices
      await db.delete('offices');

      // Insert new offices
      final cachedAt = DateTime.now().toIso8601String();
      for (final office in offices) {
        print('💾 Inserting office ${office.id}: ${office.name}');
        await db.insert('offices', {
          'id': office.id,
          'name': office.name,
          'owner_name': office.ownerName,
          'slug': office.slug,
          'logo': office.logo,
          'email': office.email,
          'phone': office.phone,
          'mobile_phone': office.mobilePhone,
          'whatsapp_number': office.whatsappNumber,
          'commercial_license': office.commercialLicense,
          'license_number': office.licenseNumber,
          'description': office.description,
          'website': office.website,
          'facebook': office.facebook,
          'instagram': office.instagram,
          'twitter': office.twitter,
          'governorate_id': office.governorateId,
          'district_id': office.districtId,
          'address': office.address,
          'latitude': office.latitude,
          'longitude': office.longitude,
          'subscription_type': office.subscriptionType,
          'subscription_start_date': office.subscriptionStartDate,
          'subscription_end_date': office.subscriptionEndDate,
          'max_properties': office.maxProperties,
          'is_verified': office.isVerified ? 1 : 0,
          'verification_date': office.verificationDate,
          'rating': office.rating,
          'total_ratings': office.totalRatings,
          'total_properties': office.totalProperties,
          'total_views': office.totalViews,
          'status': office.status,
          'created_at': office.createdAt,
          'updated_at': office.updatedAt,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${offices.length} offices');
    } catch (e, stackTrace) {
      print('❌ Error caching offices: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearOffices() async {
    final db = await databaseHelper.database;
    await db.delete('offices');
  }
}
