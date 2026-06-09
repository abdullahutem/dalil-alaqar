class ProfileOfficeEntity {
  final int id;
  final String name;
  final String ownerName;
  final String slug;
  final String? logo;
  final String email;
  final String phone;
  final String mobilePhone;
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
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final int? maxProperties;
  final bool isVerified;
  final DateTime? verificationDate;
  final String? rating;
  final int? totalRatings;
  final int? totalProperties;
  final int? totalViews;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProfileOfficeEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.slug,
    this.logo,
    required this.email,
    required this.phone,
    required this.mobilePhone,
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
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
