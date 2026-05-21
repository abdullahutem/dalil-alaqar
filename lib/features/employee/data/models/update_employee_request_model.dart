class UpdateEmployeeRequestModel {
  final String name;
  final String email;
  final String phoneNumber;
  final String whatsappNumber;
  final String userType; // "admin", "office_owner", or "office_employee"

  const UpdateEmployeeRequestModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.userType,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
      'user_type': userType,
    };
  }
}
