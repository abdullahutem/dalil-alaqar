class DistrictEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
  final int governorateId;
  final int? createdBy;
  final int? updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  DistrictEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
    required this.governorateId,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
