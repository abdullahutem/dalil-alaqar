class EmployeeStatsEntity {
  final int total;
  final int active;
  final int inactive;
  final bool canAddMore;

  const EmployeeStatsEntity({
    required this.total,
    required this.active,
    required this.inactive,
    required this.canAddMore,
  });
}
