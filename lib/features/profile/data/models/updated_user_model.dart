import '../../domain/entities/updated_user_entity.dart';

class UpdatedUserModel extends UpdatedUserEntity {
  const UpdatedUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.whatsappNumber,
  });

  factory UpdatedUserModel.fromJson(Map<String, dynamic> json) {
    return UpdatedUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      whatsappNumber: json['whatsapp_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
    };
  }
}
