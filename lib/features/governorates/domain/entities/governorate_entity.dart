class GovernorateEntity {
  final int id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
  final int? createdBy;
  final int? updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int districtsCount;

  GovernorateEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.districtsCount,
  });
}
