class UpdatedUserEntity {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? whatsappNumber;

  const UpdatedUserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.whatsappNumber,
  });
}
