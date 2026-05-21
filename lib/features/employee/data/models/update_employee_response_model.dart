import '../../domain/entities/update_employee_response_entity.dart';
import 'employee_model.dart';

class UpdateEmployeeResponseModel extends UpdateEmployeeResponseEntity {
  const UpdateEmployeeResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory UpdateEmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateEmployeeResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: EmployeeModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': (data as EmployeeModel).toJson(),
    };
  }
}
