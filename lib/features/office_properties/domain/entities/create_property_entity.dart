class CreatePropertyEntity {
  final int propertyTypeId;
  final int offerTypeId;
  final String title;
  final String description;
  final double price;
  final bool priceNegotiable;
  final int governorateId;
  final int districtId;
  final int neighborhoodId;
  final String address;
  final double latitude;
  final double longitude;
  final int currencyId;
  final String status;

  const CreatePropertyEntity({
    required this.propertyTypeId,
    required this.offerTypeId,
    required this.title,
    required this.description,
    required this.price,
    required this.priceNegotiable,
    required this.governorateId,
    required this.districtId,
    required this.neighborhoodId,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.currencyId,
    required this.status,
  });
}
