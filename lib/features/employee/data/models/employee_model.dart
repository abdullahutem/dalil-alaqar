import '../../domain/entities/employee_entity.dart';

class EmployeeOfficeModel extends EmployeeOfficeEntity {
  const EmployeeOfficeModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory EmployeeOfficeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeOfficeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.userType,
    required super.role,
    required super.office,
    required super.isActive,
    super.avatar,
    required super.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      userType: json['user_type'] as String,
      role: json['role'] as String,
      office: EmployeeOfficeModel.fromJson(
          json['office'] as Map<String, dynamic>),
      isActive: json['is_active'] as bool,
      avatar: json['avatar'] as String?,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'user_type': userType,
      'role': role,
      'office': (office as EmployeeOfficeModel).toJson(),
      'is_active': isActive,
      'avatar': avatar,
      'created_at': createdAt,
    };
  }
}
