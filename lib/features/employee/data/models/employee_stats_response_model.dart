import '../../domain/entities/employee_stats_response_entity.dart';
import 'employee_stats_model.dart';

class EmployeeStatsResponseModel extends EmployeeStatsResponseEntity {
  const EmployeeStatsResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory EmployeeStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployeeStatsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String? ?? '',
      data: EmployeeStatsModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as EmployeeStatsModel).toJson(),
    };
  }
}
