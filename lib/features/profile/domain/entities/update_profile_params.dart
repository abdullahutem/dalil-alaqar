class UpdateProfileParams {
  final String name;
  final String phoneNumber;
  final String? whatsappNumber;

  const UpdateProfileParams({
    required this.name,
    required this.phoneNumber,
    this.whatsappNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      if (whatsappNumber != null) 'whatsapp_number': whatsappNumber,
    };
  }
}
