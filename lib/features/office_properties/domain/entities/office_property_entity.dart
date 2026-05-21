import 'property_image_entity.dart';

class OfficePropertyEntity {
  final int id;
  final int officeId;
  final String officeName;
  final String officePhone;
  final String officeWhatsappNumber;
  final int propertyTypeId;
  final String propertyTypeName;
  final int offerTypeId;
  final String offerTypeName;
  final String title;
  final String description;
  final String referenceNumber;
  final double price;
  final bool priceNegotiable;
  final int governorateId;
  final String governorateName;
  final int districtId;
  final String districtName;
  final int? neighborhoodId;
  final String? neighborhoodName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String status;
  final int viewsCount;
  final String? publishedAt;
  final List<PropertyImageEntity> images;
  final String? primaryImage;
  final int? createdBy;
  final String? creatorName;
  final int? updatedBy;
  final String? updaterName;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  const OfficePropertyEntity({
    required this.id,
    required this.officeId,
    required this.officeName,
    required this.officePhone,
    required this.officeWhatsappNumber,
    required this.propertyTypeId,
    required this.propertyTypeName,
    required this.offerTypeId,
    required this.offerTypeName,
    required this.title,
    required this.description,
    required this.referenceNumber,
    required this.price,
    required this.priceNegotiable,
    required this.governorateId,
    required this.governorateName,
    required this.districtId,
    required this.districtName,
    this.neighborhoodId,
    this.neighborhoodName,
    this.address,
    this.latitude,
    this.longitude,
    required this.status,
    required this.viewsCount,
    this.publishedAt,
    required this.images,
    this.primaryImage,
    this.createdBy,
    this.creatorName,
    this.updatedBy,
    this.updaterName,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  /// Returns the primary image URL or the first image URL, or null if no images.
  String? get primaryImageUrl {
    if (images.isEmpty) return null;
    try {
      return images.firstWhere((img) => img.isPrimary).imageUrl;
    } catch (_) {
      return images.first.imageUrl;
    }
  }

  bool get isAvailable => status == 'available';
  bool get isReserved => status == 'reserved';
  bool get isSold => status == 'sold';
}
