class OfficeLogoModel {
  final String logo;
  final String logoUrl;

  const OfficeLogoModel({required this.logo, required this.logoUrl});

  factory OfficeLogoModel.fromJson(Map<String, dynamic> json) {
    return OfficeLogoModel(
      logo: json['data']['logo'] as String,
      logoUrl: json['data']['logo_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'logo': logo, 'logo_url': logoUrl};
  }
}
