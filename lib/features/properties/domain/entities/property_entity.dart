class PropertyEntity {
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
  final PropertyOffice office;
  final PropertyType propertyType;
  final OfferType offerType;
  final Governorate governorate;
  final District district;
  final Neighborhood neighborhood;
  final PrimaryImage? primaryImage;

  PropertyEntity({
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
    this.primaryImage,
  });
}

class PropertyOffice {
  final int id;
  final String name;
  final String slug;

  PropertyOffice({required this.id, required this.name, required this.slug});
}

class PropertyType {
  final int id;
  final String name;

  PropertyType({required this.id, required this.name});
}

class OfferType {
  final int id;
  final String name;

  OfferType({required this.id, required this.name});
}

class Governorate {
  final int id;
  final String nameAr;

  Governorate({required this.id, required this.nameAr});
}

class District {
  final int id;
  final String nameAr;

  District({required this.id, required this.nameAr});
}

class Neighborhood {
  final int id;
  final String nameAr;

  Neighborhood({required this.id, required this.nameAr});
}

class PrimaryImage {
  final int id;
  final int propertyId;
  final String imagePath;

  PrimaryImage({
    required this.id,
    required this.propertyId,
    required this.imagePath,
  });
}
