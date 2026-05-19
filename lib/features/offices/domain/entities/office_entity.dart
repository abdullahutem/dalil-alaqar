class OfficeEntity {
  final int id;
  final String name;
  final String? ownerName;
  final String slug;
  final String? logo;
  final String? email;
  final String? phone;
  final String? mobilePhone;
  final String? whatsappNumber;
  final String? commercialLicense;
  final String? licenseNumber;
  final String? description;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final int? governorateId;
  final int? districtId;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? subscriptionType;
  final String? subscriptionStartDate;
  final String? subscriptionEndDate;
  final int? maxProperties;
  final bool isVerified;
  final String? verificationDate;
  final double? rating;
  final int? totalRatings;
  final int? totalProperties;
  final int? totalViews;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final GovernorateEntity? governorate;
  final DistrictEntity? district;

  const OfficeEntity({
    required this.id,
    required this.name,
    this.ownerName,
    required this.slug,
    this.logo,
    this.email,
    this.phone,
    this.mobilePhone,
    this.whatsappNumber,
    this.commercialLicense,
    this.licenseNumber,
    this.description,
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    this.governorateId,
    this.districtId,
    this.address,
    this.latitude,
    this.longitude,
    this.subscriptionType,
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.maxProperties,
    required this.isVerified,
    this.verificationDate,
    this.rating,
    this.totalRatings,
    this.totalProperties,
    this.totalViews,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.governorate,
    this.district,
  });
}

class GovernorateEntity {
  final int id;
  final String nameAr;

  const GovernorateEntity({required this.id, required this.nameAr});
}

class DistrictEntity {
  final int id;
  final String nameAr;

  const DistrictEntity({required this.id, required this.nameAr});
}
