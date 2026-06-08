class UpdatePropertyEntity {
  final int propertyId;
  final String? title;
  final int? propertyTypeId;
  final int? offerTypeId;
  final String? description;
  final int? governorateId;
  final double? price;

  const UpdatePropertyEntity({
    required this.propertyId,
    this.title,
    this.propertyTypeId,
    this.offerTypeId,
    this.description,
    this.governorateId,
    this.price,
  });
}
