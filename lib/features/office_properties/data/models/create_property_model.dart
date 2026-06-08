import '../../domain/entities/create_property_entity.dart';

class CreatePropertyModel extends CreatePropertyEntity {
  const CreatePropertyModel({
    required super.propertyTypeId,
    required super.offerTypeId,
    required super.title,
    required super.description,
    required super.price,
    required super.priceNegotiable,
    required super.governorateId,
    required super.districtId,
    required super.neighborhoodId,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.currencyId,
    required super.status,
  });

  factory CreatePropertyModel.fromEntity(CreatePropertyEntity entity) {
    return CreatePropertyModel(
      propertyTypeId: entity.propertyTypeId,
      offerTypeId: entity.offerTypeId,
      title: entity.title,
      description: entity.description,
      price: entity.price,
      priceNegotiable: entity.priceNegotiable,
      governorateId: entity.governorateId,
      districtId: entity.districtId,
      neighborhoodId: entity.neighborhoodId,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      currencyId: entity.currencyId,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'property_type_id': propertyTypeId,
      'offer_type_id': offerTypeId,
      'title': title,
      'description': description,
      'price': price,
      'price_negotiable': priceNegotiable,
      'governorate_id': governorateId,
      'district_id': districtId,
      'neighborhood_id': neighborhoodId,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'currency_id': currencyId,
      'status': status,
    };
  }
}
