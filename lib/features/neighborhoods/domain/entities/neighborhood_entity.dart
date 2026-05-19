class NeighborhoodEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
  final int districtId;
  final int? createdBy;
  final int? updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  NeighborhoodEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
    required this.districtId,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
