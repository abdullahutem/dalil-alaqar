class PropertyStatsEntity {
  final int total;
  final int available;
  final int reserved;
  final int sold;
  final int rented;

  const PropertyStatsEntity({
    required this.total,
    required this.available,
    required this.reserved,
    required this.sold,
    required this.rented,
  });
}
