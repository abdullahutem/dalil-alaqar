class PropertyImageEntity {
  final int id;
  final int propertyId;
  final String imagePath;
  final bool isPrimary;
  final int order;
  final String? createdAt;
  final String? updatedAt;

  const PropertyImageEntity({
    required this.id,
    required this.propertyId,
    required this.imagePath,
    required this.isPrimary,
    required this.order,
    this.createdAt,
    this.updatedAt,
  });
}

class PropertyTypeEntity {
  final int id;
  final String name;
  final String? icon;

  const PropertyTypeEntity({required this.id, required this.name, this.icon});
}

class OfferTypeEntity {
  final int id;
  final String name;

  const OfferTypeEntity({required this.id, required this.name});
}

class PropertyGovernorateEntity {
  final int id;
  final String nameAr;

  const PropertyGovernorateEntity({required this.id, required this.nameAr});
}

class PropertyDistrictEntity {
  final int id;
  final String nameAr;

  const PropertyDistrictEntity({required this.id, required this.nameAr});
}

class PropertyNeighborhoodEntity {
  final int id;
  final String nameAr;

  const PropertyNeighborhoodEntity({required this.id, required this.nameAr});
}

class PropertyCurrencyEntity {
  final int id;
  final String name;
  final String code;
  final String symbol;

  const PropertyCurrencyEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
  });
}

class PropertyDetailsEntity {
  final int id;
  final int? officeId;
  final int? propertyTypeId;
  final int? offerTypeId;
  final String title;
  final String? description;
  final String? referenceNumber;
  final double? price;
  final int? currencyId;
  final PropertyCurrencyEntity? currency;
  final bool priceNegotiable;
  final int? governorateId;
  final int? districtId;
  final int? neighborhoodId;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? status;
  final int? viewsCount;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;

  // Relations
  final PropertyTypeEntity? propertyType;
  final OfferTypeEntity? offerType;
  final PropertyGovernorateEntity? governorate;
  final PropertyDistrictEntity? district;
  final PropertyNeighborhoodEntity? neighborhood;
  final List<PropertyImageEntity> images;
  final PropertyImageEntity? primaryImage;

  const PropertyDetailsEntity({
    required this.id,
    this.officeId,
    this.propertyTypeId,
    this.offerTypeId,
    required this.title,
    this.description,
    this.referenceNumber,
    this.price,
    this.currencyId,
    this.currency,
    required this.priceNegotiable,
    this.governorateId,
    this.districtId,
    this.neighborhoodId,
    this.address,
    this.latitude,
    this.longitude,
    this.status,
    this.viewsCount,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.propertyType,
    this.offerType,
    this.governorate,
    this.district,
    this.neighborhood,
    required this.images,
    this.primaryImage,
  });

  // Computed helpers
  bool get isForRent =>
      offerType?.id == 2 || offerType?.name.contains('إيجار') == true;
  bool get isForSale =>
      offerType?.id == 1 || offerType?.name.contains('بيع') == true;

  bool get isAvailable => status == 'available';
  bool get isReserved => status == 'reserved';
  bool get isSold => status == 'sold';

  String get fullLocation {
    final parts = <String>[];
    if (neighborhood != null) parts.add(neighborhood!.nameAr);
    if (district != null) parts.add(district!.nameAr);
    if (governorate != null) parts.add(governorate!.nameAr);
    return parts.join('، ');
  }

  bool get hasCoordinates =>
      latitude != null &&
      longitude != null &&
      double.tryParse(latitude!) != null &&
      double.tryParse(longitude!) != null;
}
