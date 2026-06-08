import 'package:dalil_alaqar/features/properties/domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  PropertyModel({
    required super.id,
    required super.officeId,
    required super.propertyTypeId,
    required super.offerTypeId,
    required super.title,
    required super.description,
    required super.referenceNumber,
    required super.price,
    super.currencyId,
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
    required super.office,
    required super.propertyType,
    required super.offerType,
    required super.governorate,
    required super.district,
    required super.neighborhood,
    super.currency,
    super.primaryImage,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] as int,
      officeId: json['office_id'] as int,
      propertyTypeId: json['property_type_id'] as int,
      offerTypeId: json['offer_type_id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      referenceNumber: json['reference_number'] as String? ?? '',
      price: json['price'] as String? ?? '0',
      currencyId: json['currency_id'] as int?,
      priceNegotiable: json['price_negotiable'] as bool? ?? false,
      governorateId: json['governorate_id'] as int,
      districtId: json['district_id'] as int,
      neighborhoodId: json['neighborhood_id'] as int,
      address: json['address'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '0',
      longitude: json['longitude'] as String? ?? '0',
      status: json['status'] as String? ?? 'active',
      viewsCount: json['views_count'] as int? ?? 0,
      publishedAt: json['published_at'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      office: _parseOffice(json['office']),
      propertyType: _parsePropertyType(json['property_type']),
      offerType: _parseOfferType(json['offer_type']),
      governorate: _parseGovernorate(json['governorate']),
      district: _parseDistrict(json['district']),
      neighborhood: _parseNeighborhood(json['neighborhood']),
      currency: _parseCurrency(json['currency']),
      primaryImage: _parsePrimaryImage(json['primary_image']),
    );
  }

  static PropertyOfficeModel _parseOffice(dynamic office) {
    if (office is Map<String, dynamic>) {
      return PropertyOfficeModel.fromJson(office);
    }
    // Fallback for when office is a string or null
    return PropertyOfficeModel(id: 0, name: 'Unknown', slug: '');
  }

  static PropertyTypeModel _parsePropertyType(dynamic propertyType) {
    if (propertyType is Map<String, dynamic>) {
      return PropertyTypeModel.fromJson(propertyType);
    }
    // Fallback for when propertyType is a string or null
    return PropertyTypeModel(id: 0, name: 'Unknown');
  }

  static OfferTypeModel _parseOfferType(dynamic offerType) {
    if (offerType is Map<String, dynamic>) {
      return OfferTypeModel.fromJson(offerType);
    }
    // Fallback for when offerType is a string or null
    return OfferTypeModel(id: 0, name: 'Unknown');
  }

  static GovernorateModel _parseGovernorate(dynamic governorate) {
    if (governorate is Map<String, dynamic>) {
      return GovernorateModel.fromJson(governorate);
    }
    // Fallback for when governorate is a string or null
    return GovernorateModel(id: 0, nameAr: 'غير معروف');
  }

  static DistrictModel _parseDistrict(dynamic district) {
    if (district is Map<String, dynamic>) {
      return DistrictModel.fromJson(district);
    }
    // Fallback for when district is a string or null
    return DistrictModel(id: 0, nameAr: 'غير معروف');
  }

  static NeighborhoodModel _parseNeighborhood(dynamic neighborhood) {
    if (neighborhood is Map<String, dynamic>) {
      return NeighborhoodModel.fromJson(neighborhood);
    }
    // Fallback for when neighborhood is a string or null
    return NeighborhoodModel(id: 0, nameAr: 'غير معروف');
  }

  static PropertyCurrencyModel? _parseCurrency(dynamic currency) {
    if (currency == null) return null;
    if (currency is Map<String, dynamic>) {
      return PropertyCurrencyModel.fromJson(currency);
    }
    // Fallback for when currency is invalid
    return null;
  }

  static PrimaryImageModel? _parsePrimaryImage(dynamic primaryImage) {
    if (primaryImage == null) return null;
    if (primaryImage is Map<String, dynamic>) {
      return PrimaryImageModel.fromJson(primaryImage);
    }
    // Fallback for when primaryImage is a string or invalid type
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'office_id': officeId,
      'property_type_id': propertyTypeId,
      'offer_type_id': offerTypeId,
      'title': title,
      'description': description,
      'reference_number': referenceNumber,
      'price': price,
      'currency_id': currencyId,
      'price_negotiable': priceNegotiable,
      'governorate_id': governorateId,
      'district_id': districtId,
      'neighborhood_id': neighborhoodId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'views_count': viewsCount,
      'published_at': publishedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'office': (office as PropertyOfficeModel).toJson(),
      'property_type': (propertyType as PropertyTypeModel).toJson(),
      'offer_type': (offerType as OfferTypeModel).toJson(),
      'governorate': (governorate as GovernorateModel).toJson(),
      'district': (district as DistrictModel).toJson(),
      'neighborhood': (neighborhood as NeighborhoodModel).toJson(),
      'currency': currency != null
          ? (currency as PropertyCurrencyModel).toJson()
          : null,
      'primary_image': primaryImage != null
          ? (primaryImage as PrimaryImageModel).toJson()
          : null,
    };
  }
}

class PropertyOfficeModel extends PropertyOffice {
  PropertyOfficeModel({
    required super.id,
    required super.name,
    required super.slug,
  });

  factory PropertyOfficeModel.fromJson(Map<String, dynamic> json) {
    return PropertyOfficeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
  }
}

class PropertyTypeModel extends PropertyType {
  PropertyTypeModel({required super.id, required super.name});

  factory PropertyTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class OfferTypeModel extends OfferType {
  OfferTypeModel({required super.id, required super.name});

  factory OfferTypeModel.fromJson(Map<String, dynamic> json) {
    return OfferTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class GovernorateModel extends Governorate {
  GovernorateModel({required super.id, required super.nameAr});

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_ar': nameAr};
  }
}

class DistrictModel extends District {
  DistrictModel({required super.id, required super.nameAr});

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_ar': nameAr};
  }
}

class NeighborhoodModel extends Neighborhood {
  NeighborhoodModel({required super.id, required super.nameAr});

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return NeighborhoodModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name_ar': nameAr};
  }
}

class PropertyCurrencyModel extends PropertyCurrency {
  PropertyCurrencyModel({
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

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'code': code, 'symbol': symbol};
  }
}

class PrimaryImageModel extends PrimaryImage {
  PrimaryImageModel({
    required super.id,
    required super.propertyId,
    required super.imagePath,
  });

  factory PrimaryImageModel.fromJson(Map<String, dynamic> json) {
    return PrimaryImageModel(
      id: json['id'] as int? ?? 0,
      propertyId: json['property_id'] as int? ?? 0,
      imagePath: json['image_path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'property_id': propertyId, 'image_path': imagePath};
  }
}
