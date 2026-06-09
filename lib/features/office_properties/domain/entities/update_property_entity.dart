class UpdatePropertyEntity {
  final int propertyId;
  final String title;
  final int propertyTypeId;
  final int offerTypeId;
  final String description;
  final int governorateId;
  final int districtId;
  final int neighborhoodId;
  final String address;
  final double price;
  final bool priceNegotiable;
  final int currencyId;

  const UpdatePropertyEntity({
    required this.propertyId,
    required this.title,
    required this.propertyTypeId,
    required this.offerTypeId,
    required this.description,
    required this.governorateId,
    required this.districtId,
    required this.neighborhoodId,
    required this.address,
    required this.price,
    required this.priceNegotiable,
    required this.currencyId,
  });
}
