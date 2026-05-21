import '../../domain/entities/delete_employee_response_entity.dart';

class DeleteEmployeeResponseModel extends DeleteEmployeeResponseEntity {
  const DeleteEmployeeResponseModel({
    required super.success,
    required super.message,
  });

  factory DeleteEmployeeResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteEmployeeResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
