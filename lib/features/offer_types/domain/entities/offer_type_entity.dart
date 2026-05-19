class OfferTypeEntity {
  final int id;
  final String name;
  final bool isActive;
  final int? createdBy;
  final int? updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  OfferTypeEntity({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
