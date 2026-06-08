import '../../domain/entities/update_property_entity.dart';

class UpdatePropertyModel extends UpdatePropertyEntity {
  const UpdatePropertyModel({
    required super.propertyId,
    super.title,
    super.propertyTypeId,
    super.offerTypeId,
    super.description,
    super.governorateId,
    super.price,
  });

  factory UpdatePropertyModel.fromEntity(UpdatePropertyEntity entity) {
    return UpdatePropertyModel(
      propertyId: entity.propertyId,
      title: entity.title,
      propertyTypeId: entity.propertyTypeId,
      offerTypeId: entity.offerTypeId,
      description: entity.description,
      governorateId: entity.governorateId,
      price: entity.price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (propertyTypeId != null) data['property_type_id'] = propertyTypeId;
    if (offerTypeId != null) data['offer_type_id'] = offerTypeId;
    if (description != null) data['description'] = description;
    if (governorateId != null) data['governorate_id'] = governorateId;
    if (price != null) data['price'] = price;

    return data;
  }
}
