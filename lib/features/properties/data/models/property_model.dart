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
      office: PropertyOfficeModel.fromJson(
        json['office'] as Map<String, dynamic>,
      ),
      propertyType: PropertyTypeModel.fromJson(
        json['property_type'] as Map<String, dynamic>,
      ),
      offerType: OfferTypeModel.fromJson(
        json['offer_type'] as Map<String, dynamic>,
      ),
      governorate: GovernorateModel.fromJson(
        json['governorate'] as Map<String, dynamic>,
      ),
      district: DistrictModel.fromJson(
        json['district'] as Map<String, dynamic>,
      ),
      neighborhood: NeighborhoodModel.fromJson(
        json['neighborhood'] as Map<String, dynamic>,
      ),
      primaryImage: json['primary_image'] != null
          ? PrimaryImageModel.fromJson(
              json['primary_image'] as Map<String, dynamic>,
            )
          : null,
    );
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

class PrimaryImageModel extends PrimaryImage {
  PrimaryImageModel({
    required super.id,
    required super.propertyId,
    required super.imagePath,
  });

  factory PrimaryImageModel.fromJson(Map<String, dynamic> json) {
    return PrimaryImageModel(
      id: json['id'] as int,
      propertyId: json['property_id'] as int,
      imagePath: json['image_path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'property_id': propertyId, 'image_path': imagePath};
  }
}
