import '../../domain/entities/profile_user_entity.dart';
import 'office_model.dart';

class ProfileUserModel extends ProfileUserEntity {
  const ProfileUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.userType,
    required super.role,
    super.officeId,
    required super.phoneNumber,
    super.whatsappNumber,
    super.address,
    required super.isActive,
    super.lastLoginAt,
    super.avatar,
    required super.locale,
    super.createdBy,
    super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    super.office,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    return ProfileUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      userType: json['user_type'] as String,
      role: json['role'] as String,
      officeId: json['office_id'] as int?,
      phoneNumber: json['phone_number'] as String,
      whatsappNumber: json['whatsapp_number'] as String?,
      address: json['address'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      avatar: json['avatar'] as String?,
      locale: json['locale'] as String,
      createdBy: json['created_by'] as int?,
      updatedBy: json['updated_by'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      office: json['office'] != null
          ? OfficeModel.fromJson(json['office'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType,
      'role': role,
      'office_id': officeId,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
      'address': address,
      'is_active': isActive,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'avatar': avatar,
      'locale': locale,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'office': office != null ? (office as OfficeModel).toJson() : null,
    };
  }
}
