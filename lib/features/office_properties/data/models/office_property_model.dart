import '../../domain/entities/office_property_entity.dart';
import 'property_image_model.dart';

class OfficePropertyCurrencyModel extends OfficePropertyCurrency {
  const OfficePropertyCurrencyModel({
    required super.id,
    required super.name,
    required super.code,
    required super.symbol,
  });

  factory OfficePropertyCurrencyModel.fromJson(Map<String, dynamic> json) {
    return OfficePropertyCurrencyModel(
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

class OfficePropertyModel extends OfficePropertyEntity {
  const OfficePropertyModel({
    required super.id,
    required super.officeId,
    required super.officeName,
    required super.officePhone,
    required super.officeWhatsappNumber,
    required super.propertyTypeId,
    required super.propertyTypeName,
    required super.offerTypeId,
    required super.offerTypeName,
    required super.title,
    required super.description,
    required super.referenceNumber,
    required super.price,
    super.currencyId,
    super.currency,
    required super.priceNegotiable,
    required super.governorateId,
    required super.governorateName,
    required super.districtId,
    required super.districtName,
    super.neighborhoodId,
    super.neighborhoodName,
    super.address,
    super.latitude,
    super.longitude,
    required super.status,
    required super.viewsCount,
    super.publishedAt,
    required super.images,
    super.primaryImage,
    super.createdBy,
    super.creatorName,
    super.updatedBy,
    super.updaterName,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
  });

  factory OfficePropertyModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List<dynamic>? ?? [])
        .map((e) => PropertyImageModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OfficePropertyModel(
      id: json['id'] as int,
      officeId: json['office_id'] as int,
      officeName: json['office_name'] as String,
      officePhone: json['office_phone'] as String,
      officeWhatsappNumber: json['office_whatsapp_number'] as String,
      propertyTypeId: json['property_type_id'] as int,
      propertyTypeName: json['property_type_name'] as String,
      offerTypeId: json['offer_type_id'] as int,
      offerTypeName: json['offer_type_name'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      referenceNumber: json['reference_number'] as String,
      price: (json['price'] as num).toDouble(),
      currencyId: json['currency_id'] as int?,
      currency: _parseCurrency(json['currency']),
      priceNegotiable: json['price_negotiable'] as bool,
      governorateId: json['governorate_id'] as int,
      governorateName: json['governorate_name'] as String,
      districtId: json['district_id'] as int,
      districtName: json['district_name'] as String,
      neighborhoodId: json['neighborhood_id'] as int?,
      neighborhoodName: json['neighborhood_name'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String,
      viewsCount: json['views_count'] as int,
      publishedAt: json['published_at'] as String?,
      images: imagesList,
      primaryImage: json['primary_image'] as String?,
      createdBy: json['created_by'] as int?,
      creatorName: json['creator_name'] as String?,
      updatedBy: json['updated_by'] as int?,
      updaterName: json['updater_name'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  static OfficePropertyCurrencyModel? _parseCurrency(dynamic currency) {
    if (currency == null) return null;
    if (currency is Map<String, dynamic>) {
      return OfficePropertyCurrencyModel.fromJson(currency);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'office_id': officeId,
      'office_name': officeName,
      'office_phone': officePhone,
      'office_whatsapp_number': officeWhatsappNumber,
      'property_type_id': propertyTypeId,
      'property_type_name': propertyTypeName,
      'offer_type_id': offerTypeId,
      'offer_type_name': offerTypeName,
      'title': title,
      'description': description,
      'reference_number': referenceNumber,
      'price': price,
      'currency_id': currencyId,
      'currency': currency != null
          ? (currency as OfficePropertyCurrencyModel).toJson()
          : null,
      'price_negotiable': priceNegotiable,
      'governorate_id': governorateId,
      'governorate_name': governorateName,
      'district_id': districtId,
      'district_name': districtName,
      'neighborhood_id': neighborhoodId,
      'neighborhood_name': neighborhoodName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'views_count': viewsCount,
      'published_at': publishedAt,
      'images': images.map((e) => (e as PropertyImageModel).toJson()).toList(),
      'primary_image': primaryImage,
      'created_by': createdBy,
      'creator_name': creatorName,
      'updated_by': updatedBy,
      'updater_name': updaterName,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
