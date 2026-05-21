class OfficeInfoEntity {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? whatsappNumber;
  final String? website;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? description;
  final String? address;
  final String? logo;
  final String? logoUrl;
  final String status;
  final String createdAt;
  final String updatedAt;

  const OfficeInfoEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.whatsappNumber,
    this.website,
    this.facebook,
    this.instagram,
    this.twitter,
    this.description,
    this.address,
    this.logo,
    this.logoUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == 'active';
}
