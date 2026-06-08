import '../../domain/entities/property_details_entity.dart';

class PropertyImageDetailsModel extends PropertyImageEntity {
  const PropertyImageDetailsModel({
    required int id,
    required int propertyId,
    required String imagePath,
    required bool isPrimary,
    required int order,
    String? createdAt,
    String? updatedAt,
  }) : super(
         id: id,
         propertyId: propertyId,
         imagePath: imagePath,
         isPrimary: isPrimary,
         order: order,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory PropertyImageDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageDetailsModel(
      id: json['id'] as int,
      propertyId: json['property_id'] as int? ?? 0,
      imagePath: json['image_path'] as String,
      isPrimary: (json['is_primary'] as bool?) ?? false,
      order: (json['order'] as int?) ?? 0,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class PropertyTypeModel extends PropertyTypeEntity {
  const PropertyTypeModel({required super.id, required super.name, super.icon});

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}

class OfferTypeModel extends OfferTypeEntity {
  const OfferTypeModel({required super.id, required super.name});

  factory OfferTypeModel.fromJson(Map<String, dynamic> json) {
    return OfferTypeModel(id: json['id'] as int, name: json['name'] as String);
  }
}

class PropertyGovernorateModel extends PropertyGovernorateEntity {
  const PropertyGovernorateModel({required super.id, required super.nameAr});

  factory PropertyGovernorateModel.fromJson(Map<String, dynamic> json) {
    return PropertyGovernorateModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }
}

class PropertyDistrictModel extends PropertyDistrictEntity {
  const PropertyDistrictModel({required super.id, required super.nameAr});

  factory PropertyDistrictModel.fromJson(Map<String, dynamic> json) {
    return PropertyDistrictModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }
}

class PropertyNeighborhoodModel extends PropertyNeighborhoodEntity {
  const PropertyNeighborhoodModel({required super.id, required super.nameAr});

  factory PropertyNeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return PropertyNeighborhoodModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
    );
  }
}

class PropertyCurrencyModel extends PropertyCurrencyEntity {
  const PropertyCurrencyModel({
    required super.id,
    required super.name,
    required super.code,
    required super.symbol,
  });

  factory PropertyCurrencyModel.fromJson(Map<String, dynamic> json) {
    return PropertyCurrencyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
    );
  }
}

class PropertyDetailsModel extends PropertyDetailsEntity {
  const PropertyDetailsModel({
    required super.id,
    super.officeId,
    super.propertyTypeId,
    super.offerTypeId,
    required super.title,
    super.description,
    super.referenceNumber,
    super.price,
    super.currencyId,
    super.currency,
    required super.priceNegotiable,
    super.governorateId,
    super.districtId,
    super.neighborhoodId,
    super.address,
    super.latitude,
    super.longitude,
    super.status,
    super.viewsCount,
    super.publishedAt,
    super.createdAt,
    super.updatedAt,
    super.propertyType,
    super.offerType,
    super.governorate,
    super.district,
    super.neighborhood,
    required super.images,
    super.primaryImage,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsModel(
      id: json['id'] as int,
      officeId: json['office_id'] as int?,
      propertyTypeId: json['property_type_id'] as int?,
      offerTypeId: json['offer_type_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      referenceNumber: json['reference_number'] as String?,
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      currencyId: json['currency_id'] as int?,
      currency: json['currency'] != null
          ? PropertyCurrencyModel.fromJson(
              json['currency'] as Map<String, dynamic>,
            )
          : null,
      priceNegotiable: (json['price_negotiable'] as bool?) ?? false,
      governorateId: json['governorate_id'] as int?,
      districtId: json['district_id'] as int?,
      neighborhoodId: json['neighborhood_id'] as int?,
      address: json['address'] as String?,
      latitude: json['latitude'] != null ? json['latitude'].toString() : null,
      longitude: json['longitude'] != null
          ? json['longitude'].toString()
          : null,
      status: json['status'] as String?,
      viewsCount: json['views_count'] as int?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      propertyType: json['property_type'] != null
          ? PropertyTypeModel.fromJson(
              json['property_type'] as Map<String, dynamic>,
            )
          : null,
      offerType: json['offer_type'] != null
          ? OfferTypeModel.fromJson(json['offer_type'] as Map<String, dynamic>)
          : null,
      governorate: json['governorate'] != null
          ? PropertyGovernorateModel.fromJson(
              json['governorate'] as Map<String, dynamic>,
            )
          : null,
      district: json['district'] != null
          ? PropertyDistrictModel.fromJson(
              json['district'] as Map<String, dynamic>,
            )
          : null,
      neighborhood: json['neighborhood'] != null
          ? PropertyNeighborhoodModel.fromJson(
              json['neighborhood'] as Map<String, dynamic>,
            )
          : null,
      images:
          (json['images'] as List<dynamic>?)
              ?.map(
                (e) => PropertyImageDetailsModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      // primary_image is a string path in the API, not an object
      // Use the first image marked as primary from the images list
      primaryImage: null,
    );
  }
}
