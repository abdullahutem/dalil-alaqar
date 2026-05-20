class AddEmployeeRequestModel {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String whatsappNumber;
  final String address;
  final String role; // "manager" or "employee"

  const AddEmployeeRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.address,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
      'address': address,
      'role': role,
    };
  }
}
