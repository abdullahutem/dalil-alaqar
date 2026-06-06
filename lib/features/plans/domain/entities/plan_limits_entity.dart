class PlanLimitsEntity {
  final int maxProperties;
  final int maxEmployees;
  final bool isUnlimitedProperties;
  final bool isUnlimitedEmployees;

  const PlanLimitsEntity({
    required this.maxProperties,
    required this.maxEmployees,
    required this.isUnlimitedProperties,
    required this.isUnlimitedEmployees,
  });
}
