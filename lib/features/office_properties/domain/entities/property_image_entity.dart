class PropertyImageEntity {
  final int id;
  final String imagePath;
  final String imageUrl;
  final bool isPrimary;
  final int order;

  const PropertyImageEntity({
    required this.id,
    required this.imagePath,
    required this.imageUrl,
    required this.isPrimary,
    required this.order,
  });
}
