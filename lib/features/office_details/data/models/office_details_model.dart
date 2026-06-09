import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

class OfficeDetailsModel extends OfficeDetailsEntity {
  const OfficeDetailsModel({
    required super.id,
    required super.name,
    required super.ownerName,
    required super.slug,
    super.logo,
    required super.email,
    required super.phone,
    required super.mobilePhone,
    required super.whatsappNumber,
    required super.commercialLicense,
    super.licenseNumber,
    required super.description,
    super.website,
    super.facebook,
    super.instagram,
    super.twitter,
    required super.governorateId,
    required super.districtId,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.subscriptionType,
    required super.subscriptionStartDate,
    required super.subscriptionEndDate,
    required super.maxProperties,
    required super.isVerified,
    super.verificationDate,
    required super.rating,
    required super.totalRatings,
    required super.totalProperties,
    required super.totalViews,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    required super.governorate,
    required super.district,
    required super.recentProperties,
  });

  factory OfficeDetailsModel.fromJson(Map<String, dynamic> json) {
    return OfficeDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      slug: json['slug'] ?? '',
      logo: json['logo'],
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      mobilePhone: json['mobile_phone'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      commercialLicense: json['commercial_license'] ?? '',
      licenseNumber: json['license_number'],
      description: json['description'] ?? '',
      website: json['website'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      twitter: json['twitter'],
      governorateId: json['governorate_id'] ?? 0,
      districtId: json['district_id'] ?? 0,
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
      subscriptionType: json['subscription_type'] ?? '',
      subscriptionStartDate: json['subscription_start_date'] ?? '',
      subscriptionEndDate: json['subscription_end_date'] ?? '',
      maxProperties: json['max_properties'] ?? 0,
      isVerified: json['is_verified'] ?? false,
      verificationDate: json['verification_date'],
      rating: json['rating']?.toString() ?? '0',
      totalRatings: json['total_ratings'] ?? 0,
      totalProperties: json['total_properties'] ?? 0,
      totalViews: json['total_views'] ?? 0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      governorate: GovernorateInfoModel.fromJson(json['governorate'] ?? {}),
      district: DistrictInfoModel.fromJson(json['district'] ?? {}),
      recentProperties:
          (json['recent_properties'] as List?)
              ?.map((e) => RecentPropertyInfoModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class GovernorateInfoModel extends GovernorateInfo {
  const GovernorateInfoModel({required super.id, required super.nameAr});

  factory GovernorateInfoModel.fromJson(Map<String, dynamic> json) {
    return GovernorateInfoModel(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
    );
  }
}

class DistrictInfoModel extends DistrictInfo {
  const DistrictInfoModel({required super.id, required super.nameAr});

  factory DistrictInfoModel.fromJson(Map<String, dynamic> json) {
    return DistrictInfoModel(
      id: json['id'] ?? 0,
      nameAr: json['name_ar'] ?? '',
    );
  }
}

class RecentPropertyInfoModel extends RecentPropertyInfo {
  const RecentPropertyInfoModel({
    required super.id,
    required super.officeId,
    required super.propertyTypeId,
    required super.offerTypeId,
    required super.title,
    required super.description,
    required super.referenceNumber,
    required super.price,
    required super.priceNegotiable,
    required super.governorateId,
    required super.districtId,
    required super.neighborhoodId,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.viewsCount,
    required super.publishedAt,
    required super.createdAt,
    required super.updatedAt,
    required super.propertyType,
    required super.offerType,
    super.primaryImage,
  });

  factory RecentPropertyInfoModel.fromJson(Map<String, dynamic> json) {
    return RecentPropertyInfoModel(
      id: json['id'] ?? 0,
      officeId: json['office_id'] ?? 0,
      propertyTypeId: json['property_type_id'] ?? 0,
      offerTypeId: json['offer_type_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      referenceNumber: json['reference_number'] ?? '',
      price: json['price']?.toString() ?? '0',
      priceNegotiable: json['price_negotiable'] ?? false,
      governorateId: json['governorate_id'] ?? 0,
      districtId: json['district_id'] ?? 0,
      neighborhoodId: json['neighborhood_id'] ?? 0,
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? '0',
      longitude: json['longitude'] ?? '0',
      status: json['status'] ?? '',
      viewsCount: json['views_count'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      propertyType: PropertyTypeInfoModel.fromJson(json['property_type'] ?? {}),
      offerType: OfferTypeInfoModel.fromJson(json['offer_type'] ?? {}),
      primaryImage: json['primary_image'] as String?,
    );
  }
}

class PropertyTypeInfoModel extends PropertyTypeInfo {
  const PropertyTypeInfoModel({required super.id, required super.name});

  factory PropertyTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeInfoModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class OfferTypeInfoModel extends OfferTypeInfo {
  const OfferTypeInfoModel({required super.id, required super.name});

  factory OfferTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return OfferTypeInfoModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class PrimaryImageInfoModel extends PrimaryImageInfo {
  const PrimaryImageInfoModel({
    required super.id,
    required super.propertyId,
    required super.imagePath,
    required super.isPrimary,
    required super.order,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PrimaryImageInfoModel.fromJson(Map<String, dynamic> json) {
    return PrimaryImageInfoModel(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      imagePath: json['image_path'] ?? '',
      isPrimary: json['is_primary'] ?? false,
      order: json['order'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
