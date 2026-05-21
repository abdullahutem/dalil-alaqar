import '../../domain/entities/employee_stats_entity.dart';

class EmployeeStatsModel extends EmployeeStatsEntity {
  const EmployeeStatsModel({
    required super.total,
    required super.active,
    required super.inactive,
    required super.canAddMore,
  });

  factory EmployeeStatsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeStatsModel(
      total: json['total'] as int,
      active: json['active'] as int,
      inactive: json['inactive'] as int,
      canAddMore: json['can_add_more'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'can_add_more': canAddMore,
    };
  }
}
