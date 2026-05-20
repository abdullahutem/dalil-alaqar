class OfficeDetailsEntity {
  final int id;
  final String name;
  final String ownerName;
  final String slug;
  final String? logo;
  final String email;
  final String phone;
  final String mobilePhone;
  final String whatsappNumber;
  final String commercialLicense;
  final String? licenseNumber;
  final String description;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final int governorateId;
  final int districtId;
  final String address;
  final String latitude;
  final String longitude;
  final String subscriptionType;
  final String subscriptionStartDate;
  final String subscriptionEndDate;
  final int maxProperties;
  final bool isVerified;
  final String? verificationDate;
  final String rating;
  final int totalRatings;
  final int totalProperties;
  final int totalViews;
  final String status;
  final String createdAt;
  final String updatedAt;
  final GovernorateInfo governorate;
  final DistrictInfo district;
  final List<RecentPropertyInfo> recentProperties;

  const OfficeDetailsEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.slug,
    this.logo,
    required this.email,
    required this.phone,
    required this.mobilePhone,
    required this.whatsappNumber,
    required this.commercialLicense,
    this.licenseNumber,
    required this.description,
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    required this.governorateId,
    required this.districtId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.subscriptionType,
    required this.subscriptionStartDate,
    required this.subscriptionEndDate,
    required this.maxProperties,
    required this.isVerified,
    this.verificationDate,
    required this.rating,
    required this.totalRatings,
    required this.totalProperties,
    required this.totalViews,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.governorate,
    required this.district,
    required this.recentProperties,
  });
}

class GovernorateInfo {
  final int id;
  final String nameAr;

  const GovernorateInfo({required this.id, required this.nameAr});
}

class DistrictInfo {
  final int id;
  final String nameAr;

  const DistrictInfo({required this.id, required this.nameAr});
}

class RecentPropertyInfo {
  final int id;
  final int officeId;
  final int propertyTypeId;
  final int offerTypeId;
  final String title;
  final String description;
  final String referenceNumber;
  final String price;
  final bool priceNegotiable;
  final int governorateId;
  final int districtId;
  final int neighborhoodId;
  final String address;
  final String latitude;
  final String longitude;
  final String status;
  final int viewsCount;
  final String publishedAt;
  final String createdAt;
  final String updatedAt;
  final PropertyTypeInfo propertyType;
  final OfferTypeInfo offerType;
  final PrimaryImageInfo? primaryImage;

  const RecentPropertyInfo({
    required this.id,
    required this.officeId,
    required this.propertyTypeId,
    required this.offerTypeId,
    required this.title,
    required this.description,
    required this.referenceNumber,
    required this.price,
    required this.priceNegotiable,
    required this.governorateId,
    required this.districtId,
    required this.neighborhoodId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.viewsCount,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.propertyType,
    required this.offerType,
    this.primaryImage,
  });
}

class PropertyTypeInfo {
  final int id;
  final String name;

  const PropertyTypeInfo({required this.id, required this.name});
}

class OfferTypeInfo {
  final int id;
  final String name;

  const OfferTypeInfo({required this.id, required this.name});
}

class PrimaryImageInfo {
  final int id;
  final int propertyId;
  final String imagePath;
  final bool isPrimary;
  final int order;
  final String createdAt;
  final String updatedAt;

  const PrimaryImageInfo({
    required this.id,
    required this.propertyId,
    required this.imagePath,
    required this.isPrimary,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });
}
