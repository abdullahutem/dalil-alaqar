class SlideEntity {
  final int id;
  final String title;
  final String description;
  final String image;
  final String link;
  final String position;
  final int order;
  final int? officeId; // Nullable - some ads are not tied to a specific office
  final String startDate;
  final String endDate;
  final int viewsCount;
  final int clicksCount;
  final bool isActive;
  final String status;
  final String createdAt;
  final String updatedAt;

  SlideEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.link,
    required this.position,
    required this.order,
    this.officeId, // Optional
    required this.startDate,
    required this.endDate,
    required this.viewsCount,
    required this.clicksCount,
    required this.isActive,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
