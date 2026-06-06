import '../../domain/entities/plan_entity.dart';
import 'plan_limits_model.dart';
import 'plan_prices_model.dart';

class PlanModel extends PlanEntity {
  const PlanModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.prices,
    required super.limits,
    required super.features,
    required super.priorityLevel,
    required super.trialDays,
    required super.hasTrial,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      prices: PlanPricesModel.fromJson(json['prices'] as Map<String, dynamic>),
      limits: PlanLimitsModel.fromJson(json['limits'] as Map<String, dynamic>),
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      priorityLevel: json['priority_level'] as int,
      trialDays: json['trial_days'] as int,
      hasTrial: json['has_trial'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'prices': (prices as PlanPricesModel).toJson(),
      'limits': (limits as PlanLimitsModel).toJson(),
      'features': features,
      'priority_level': priorityLevel,
      'trial_days': trialDays,
      'has_trial': hasTrial,
    };
  }
}
