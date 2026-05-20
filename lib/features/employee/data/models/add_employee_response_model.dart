import '../../domain/entities/add_employee_response_entity.dart';
import 'employee_model.dart';

class AddEmployeeResponseModel extends AddEmployeeResponseEntity {
  const AddEmployeeResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory AddEmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return AddEmployeeResponseModel(
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
