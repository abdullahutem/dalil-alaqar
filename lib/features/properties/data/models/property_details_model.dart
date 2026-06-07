import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';

class PropertyDetailsModel extends PropertyDetailsEntity {
  PropertyDetailsModel({
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
    required super.images,
    super.primaryImage,
  });

  factory PropertyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsModel(
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
      status: json['status'] as String? ?? 'available',
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
      images: _parseImages(json['images']),
      primaryImage: _parsePrimaryImage(json['primary_image']),
    );
  }

  static PropertyDetailsOfficeModel _parseOffice(dynamic office) {
    if (office is Map<String, dynamic>) {
      return PropertyDetailsOfficeModel.fromJson(office);
    }
    return PropertyDetailsOfficeModel(
      id: 0,
      name: 'Unknown',
      slug: '',
      email: '',
      phone: '',
      whatsappNumber: '',
    );
  }

  static PropertyDetailsTypeModel _parsePropertyType(dynamic propertyType) {
    if (propertyType is Map<String, dynamic>) {
      return PropertyDetailsTypeModel.fromJson(propertyType);
    }
    return PropertyDetailsTypeModel(id: 0, name: 'Unknown', icon: '');
  }

  static PropertyDetailsOfferTypeModel _parseOfferType(dynamic offerType) {
    if (offerType is Map<String, dynamic>) {
      return PropertyDetailsOfferTypeModel.fromJson(offerType);
    }
    return PropertyDetailsOfferTypeModel(id: 0, name: 'Unknown');
  }

  static PropertyDetailsGovernorateModel _parseGovernorate(
    dynamic governorate,
  ) {
    if (governorate is Map<String, dynamic>) {
      return PropertyDetailsGovernorateModel.fromJson(governorate);
    }
    return PropertyDetailsGovernorateModel(id: 0, nameAr: 'غير معروف');
  }

  static PropertyDetailsDistrictModel _parseDistrict(dynamic district) {
    if (district is Map<String, dynamic>) {
      return PropertyDetailsDistrictModel.fromJson(district);
    }
    return PropertyDetailsDistrictModel(id: 0, nameAr: 'غير معروف');
  }

  static PropertyDetailsNeighborhoodModel _parseNeighborhood(
    dynamic neighborhood,
  ) {
    if (neighborhood is Map<String, dynamic>) {
      return PropertyDetailsNeighborhoodModel.fromJson(neighborhood);
    }
    return PropertyDetailsNeighborhoodModel(id: 0, nameAr: 'غير معروف');
  }

  static List<PropertyImageModel> _parseImages(dynamic images) {
    if (images is List<dynamic>) {
      return images
          .where((e) => e is Map<String, dynamic>)
          .map((e) => PropertyImageModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  static PropertyImageModel? _parsePrimaryImage(dynamic primaryImage) {
    if (primaryImage == null) return null;
    if (primaryImage is Map<String, dynamic>) {
      return PropertyImageModel.fromJson(primaryImage);
    }
    return null;
  }
}

class PropertyDetailsOfficeModel extends PropertyDetailsOffice {
  PropertyDetailsOfficeModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.email,
    required super.phone,
    required super.whatsappNumber,
  });

  factory PropertyDetailsOfficeModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsOfficeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      whatsappNumber: json['whatsapp_number'] as String? ?? '',
    );
  }
}

class PropertyDetailsTypeModel extends PropertyDetailsType {
  PropertyDetailsTypeModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory PropertyDetailsTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
    );
  }
}

class PropertyDetailsOfferTypeModel extends PropertyDetailsOfferType {
  PropertyDetailsOfferTypeModel({required super.id, required super.name});

  factory PropertyDetailsOfferTypeModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsOfferTypeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}

class PropertyDetailsGovernorateModel extends PropertyDetailsGovernorate {
  PropertyDetailsGovernorateModel({required super.id, required super.nameAr});

  factory PropertyDetailsGovernorateModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsGovernorateModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }
}

class PropertyDetailsDistrictModel extends PropertyDetailsDistrict {
  PropertyDetailsDistrictModel({required super.id, required super.nameAr});

  factory PropertyDetailsDistrictModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsDistrictModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }
}

class PropertyDetailsNeighborhoodModel extends PropertyDetailsNeighborhood {
  PropertyDetailsNeighborhoodModel({required super.id, required super.nameAr});

  factory PropertyDetailsNeighborhoodModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsNeighborhoodModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String? ?? '',
    );
  }
}

class PropertyImageModel extends PropertyImage {
  PropertyImageModel({
    required super.id,
    required super.propertyId,
    required super.imagePath,
    required super.isPrimary,
    required super.order,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PropertyImageModel.fromJson(Map<String, dynamic> json) {
    return PropertyImageModel(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      imagePath: json['image_path'] as String? ?? '',
      isPrimary: json['is_primary'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}
