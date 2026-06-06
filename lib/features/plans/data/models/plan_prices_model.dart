import '../../domain/entities/plan_prices_entity.dart';

class PlanPricesModel extends PlanPricesEntity {
  const PlanPricesModel({
    required super.monthly,
    required super.quarterly,
    required super.semiAnnual,
    required super.annual,
  });

  factory PlanPricesModel.fromJson(Map<String, dynamic> json) {
    return PlanPricesModel(
      monthly: json['monthly'] as String,
      quarterly: json['quarterly'] as String,
      semiAnnual: json['semi_annual'] as String,
      annual: json['annual'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly': monthly,
      'quarterly': quarterly,
      'semi_annual': semiAnnual,
      'annual': annual,
    };
  }
}
