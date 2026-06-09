import '../../domain/entities/update_property_entity.dart';

class UpdatePropertyModel extends UpdatePropertyEntity {
  const UpdatePropertyModel({
    required super.propertyId,
    required super.title,
    required super.propertyTypeId,
    required super.offerTypeId,
    required super.description,
    required super.governorateId,
    required super.districtId,
    required super.neighborhoodId,
    required super.address,
    required super.price,
    required super.priceNegotiable,
    required super.currencyId,
  });

  factory UpdatePropertyModel.fromEntity(UpdatePropertyEntity entity) {
    return UpdatePropertyModel(
      propertyId: entity.propertyId,
      title: entity.title,
      propertyTypeId: entity.propertyTypeId,
      offerTypeId: entity.offerTypeId,
      description: entity.description,
      governorateId: entity.governorateId,
      districtId: entity.districtId,
      neighborhoodId: entity.neighborhoodId,
      address: entity.address,
      price: entity.price,
      priceNegotiable: entity.priceNegotiable,
      currencyId: entity.currencyId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'property_type_id': propertyTypeId,
      'offer_type_id': offerTypeId,
      'description': description,
      'governorate_id': governorateId,
      'district_id': districtId,
      'neighborhood_id': neighborhoodId,
      'address': address,
      'price': price,
      'price_negotiable': priceNegotiable,
      'currency_id': currencyId,
    };
  }
}
