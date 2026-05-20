class EmployeeOfficeEntity {
  final int id;
  final String name;
  final String email;

  const EmployeeOfficeEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}

class EmployeeEntity {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String userType;
  final String role;
  final EmployeeOfficeEntity office;
  final bool isActive;
  final String? avatar;
  final String createdAt;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.userType,
    required this.role,
    required this.office,
    required this.isActive,
    this.avatar,
    required this.createdAt,
  });
}
