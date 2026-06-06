import 'plan_limits_entity.dart';
import 'plan_prices_entity.dart';

class PlanEntity {
  final int id;
  final String name;
  final String slug;
  final String description;
  final PlanPricesEntity prices;
  final PlanLimitsEntity limits;
  final List<String> features;
  final int priorityLevel;
  final int trialDays;
  final bool hasTrial;

  const PlanEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.prices,
    required this.limits,
    required this.features,
    required this.priorityLevel,
    required this.trialDays,
    required this.hasTrial,
  });
}
