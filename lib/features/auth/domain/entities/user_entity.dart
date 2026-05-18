class UserEntity {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? whatsappNumber;
  final String? type;
  final bool isActive;
  final List<String> roles;
  final List<String> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.whatsappNumber,
    this.type,
    required this.isActive,
    required this.roles,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
  });
}
