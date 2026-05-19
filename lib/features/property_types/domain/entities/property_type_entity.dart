class PropertyTypeEntity {
  final int id;
  final String name;
  final String icon;
  final String? description;
  final int order;
  final bool isActive;
  final int? createdBy;
  final int? updatedBy;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  PropertyTypeEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.description,
    required this.order,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
}
