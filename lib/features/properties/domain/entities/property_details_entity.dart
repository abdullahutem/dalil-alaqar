class PropertyDetailsEntity {
  final int id;
  final int officeId;
  final int propertyTypeId;
  final int offerTypeId;
  final String title;
  final String description;
  final String referenceNumber;
  final String price;
  final int? currencyId;
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

  // Nested objects
  final PropertyDetailsOffice office;
  final PropertyDetailsType propertyType;
  final PropertyDetailsOfferType offerType;
  final PropertyDetailsGovernorate governorate;
  final PropertyDetailsDistrict district;
  final PropertyDetailsNeighborhood neighborhood;
  final PropertyDetailsCurrency? currency;
  final List<PropertyImage> images;
  final PropertyImage? primaryImage;

  PropertyDetailsEntity({
    required this.id,
    required this.officeId,
    required this.propertyTypeId,
    required this.offerTypeId,
    required this.title,
    required this.description,
    required this.referenceNumber,
    required this.price,
    this.currencyId,
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
    required this.office,
    required this.propertyType,
    required this.offerType,
    required this.governorate,
    required this.district,
    required this.neighborhood,
    this.currency,
    required this.images,
    this.primaryImage,
  });
}

class PropertyDetailsOffice {
  final int id;
  final String name;
  final String slug;
  final String email;
  final String phone;
  final String whatsappNumber;

  PropertyDetailsOffice({
    required this.id,
    required this.name,
    required this.slug,
    required this.email,
    required this.phone,
    required this.whatsappNumber,
  });
}

class PropertyDetailsType {
  final int id;
  final String name;
  final String icon;

  PropertyDetailsType({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class PropertyDetailsOfferType {
  final int id;
  final String name;

  PropertyDetailsOfferType({required this.id, required this.name});
}

class PropertyDetailsGovernorate {
  final int id;
  final String nameAr;

  PropertyDetailsGovernorate({required this.id, required this.nameAr});
}

class PropertyDetailsDistrict {
  final int id;
  final String nameAr;

  PropertyDetailsDistrict({required this.id, required this.nameAr});
}

class PropertyDetailsNeighborhood {
  final int id;
  final String nameAr;

  PropertyDetailsNeighborhood({required this.id, required this.nameAr});
}

class PropertyDetailsCurrency {
  final int id;
  final String name;
  final String code;
  final String symbol;

  PropertyDetailsCurrency({
    required this.id,
    required this.name,
    required this.code,
    required this.symbol,
  });
}

class PropertyImage {
  final int id;
  final int propertyId;
  final String imagePath;
  final bool isPrimary;
  final int order;
  final String createdAt;
  final String updatedAt;

  PropertyImage({
    required this.id,
    required this.propertyId,
    required this.imagePath,
    required this.isPrimary,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });
}
