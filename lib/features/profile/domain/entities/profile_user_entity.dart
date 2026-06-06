import 'office_entity.dart';

class ProfileUserEntity {
  final int id;
  final String name;
  final String email;
  final String userType;
  final String role;
  final int? officeId;
  final String phoneNumber;
  final String? whatsappNumber;
  final String? address;
  final bool isActive;
  final DateTime? lastLoginAt;
  final String? avatar;
  final String locale;
  final int? createdBy;
  final int? updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OfficeEntity? office;

  const ProfileUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.role,
    this.officeId,
    required this.phoneNumber,
    this.whatsappNumber,
    this.address,
    required this.isActive,
    this.lastLoginAt,
    this.avatar,
    required this.locale,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    this.office,
  });
}
