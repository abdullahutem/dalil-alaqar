import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';

class OfficeModel extends OfficeEntity {
  const OfficeModel({
    required super.id,
    required super.name,
    super.ownerName,
    required super.slug,
    super.logo,
    super.email,
    super.phone,
    super.mobilePhone,
    super.whatsappNumber,
    super.commercialLicense,
    super.licenseNumber,
    super.description,
    super.website,
    super.facebook,
    super.instagram,
    super.twitter,
    super.governorateId,
    super.districtId,
    super.address,
    super.latitude,
    super.longitude,
    super.subscriptionType,
    super.subscriptionStartDate,
    super.subscriptionEndDate,
    super.maxProperties,
    required super.isVerified,
    super.verificationDate,
    super.rating,
    super.totalRatings,
    super.totalProperties,
    super.totalViews,
    super.status,
    super.createdAt,
    super.updatedAt,
    super.governorate,
    super.district,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
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
      isVerified: (json['is_verified'] as bool?) ?? false,
      verificationDate: json['verification_date'] as String?,
      rating: (json['rating'] != null)
          ? double.tryParse(json['rating'].toString())
          : null,
      totalRatings: json['total_ratings'] as int?,
      totalProperties: json['total_properties'] as int?,
      totalViews: json['total_views'] as int?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      governorate: json['governorate'] != null
          ? GovernorateModel.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      district: json['district'] != null
          ? DistrictModel.fromJson(json['district'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner_name': ownerName,
      'slug': slug,
      'logo': logo,
      'email': email,
      'phone': phone,
      'mobile_phone': mobilePhone,
      'whatsapp_number': whatsappNumber,
      'commercial_license': commercialLicense,
      'license_number': licenseNumber,
      'description': description,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'governorate_id': governorateId,
      'district_id': districtId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'subscription_type': subscriptionType,
      'subscription_start_date': subscriptionStartDate,
      'subscription_end_date': subscriptionEndDate,
      'max_properties': maxProperties,
      'is_verified': isVerified,
      'verification_date': verificationDate,
      'rating': rating,
      'total_ratings': totalRatings,
      'total_properties': totalProperties,
      'total_views': totalViews,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class GovernorateModel extends GovernorateEntity {
  const GovernorateModel({required super.id, required super.nameAr});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }
}

class DistrictModel extends DistrictEntity {
  const DistrictModel({required super.id, required super.nameAr});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }
}
