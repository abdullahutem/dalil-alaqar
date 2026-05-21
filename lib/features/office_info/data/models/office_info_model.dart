import '../../domain/entities/office_info_entity.dart';

class OfficeInfoModel extends OfficeInfoEntity {
  const OfficeInfoModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.whatsappNumber,
    super.website,
    super.facebook,
    super.instagram,
    super.twitter,
    super.description,
    super.address,
    super.logo,
    super.logoUrl,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OfficeInfoModel.fromJson(Map<String, dynamic> json) {
    return OfficeInfoModel(
      id: json['data']['id'] as int,
      name: json['data']['name'] as String,
      email: json['data']['email'] as String,
      phone: json['data']['phone'] as String,
      whatsappNumber: json['data']['whatsapp_number'] as String?,
      website: json['data']['website'] as String?,
      facebook: json['data']['facebook'] as String?,
      instagram: json['data']['instagram'] as String?,
      twitter: json['data']['twitter'] as String?,
      description: json['data']['description'] as String?,
      address: json['data']['address'] as String?,
      logo: json['data']['logo'] as String?,
      logoUrl: json['data']['logo_url'] as String?,
      status: json['data']['status'] as String,
      createdAt: json['data']['created_at'] as String,
      updatedAt: json['data']['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'whatsapp_number': whatsappNumber,
      'website': website,
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'description': description,
      'address': address,
      'logo': logo,
      'logo_url': logoUrl,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
