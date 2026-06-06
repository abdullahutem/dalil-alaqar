import '../../domain/entities/plan_limits_entity.dart';

class PlanLimitsModel extends PlanLimitsEntity {
  const PlanLimitsModel({
    required super.maxProperties,
    required super.maxEmployees,
    required super.isUnlimitedProperties,
    required super.isUnlimitedEmployees,
  });

  factory PlanLimitsModel.fromJson(Map<String, dynamic> json) {
    return PlanLimitsModel(
      maxProperties: json['max_properties'] as int,
      maxEmployees: json['max_employees'] as int,
      isUnlimitedProperties: json['is_unlimited_properties'] as bool,
      isUnlimitedEmployees: json['is_unlimited_employees'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'max_properties': maxProperties,
      'max_employees': maxEmployees,
      'is_unlimited_properties': isUnlimitedProperties,
      'is_unlimited_employees': isUnlimitedEmployees,
    };
  }
}
