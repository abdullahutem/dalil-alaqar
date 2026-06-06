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

  OfficePropertyEntity copyWith({
    int? id,
    int? officeId,
    String? officeName,
    String? officePhone,
    String? officeWhatsappNumber,
    int? propertyTypeId,
    String? propertyTypeName,
    int? offerTypeId,
    String? offerTypeName,
    String? title,
    String? description,
    String? referenceNumber,
    double? price,
    bool? priceNegotiable,
    int? governorateId,
    String? governorateName,
    int? districtId,
    String? districtName,
    int? neighborhoodId,
    String? neighborhoodName,
    String? address,
    double? latitude,
    double? longitude,
    String? status,
    int? viewsCount,
    String? publishedAt,
    List<PropertyImageEntity>? images,
    String? primaryImage,
    int? createdBy,
    String? creatorName,
    int? updatedBy,
    String? updaterName,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return OfficePropertyEntity(
      id: id ?? this.id,
      officeId: officeId ?? this.officeId,
      officeName: officeName ?? this.officeName,
      officePhone: officePhone ?? this.officePhone,
      officeWhatsappNumber: officeWhatsappNumber ?? this.officeWhatsappNumber,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      propertyTypeName: propertyTypeName ?? this.propertyTypeName,
      offerTypeId: offerTypeId ?? this.offerTypeId,
      offerTypeName: offerTypeName ?? this.offerTypeName,
      title: title ?? this.title,
      description: description ?? this.description,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      price: price ?? this.price,
      priceNegotiable: priceNegotiable ?? this.priceNegotiable,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      neighborhoodId: neighborhoodId ?? this.neighborhoodId,
      neighborhoodName: neighborhoodName ?? this.neighborhoodName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      viewsCount: viewsCount ?? this.viewsCount,
      publishedAt: publishedAt ?? this.publishedAt,
      images: images ?? this.images,
      primaryImage: primaryImage ?? this.primaryImage,
      createdBy: createdBy ?? this.createdBy,
      creatorName: creatorName ?? this.creatorName,
      updatedBy: updatedBy ?? this.updatedBy,
      updaterName: updaterName ?? this.updaterName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
