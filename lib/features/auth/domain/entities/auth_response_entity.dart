import 'package:dalil_alaqar/features/auth/domain/entities/user_entity.dart';

class AuthResponseEntity {
  final UserEntity user;
  final String token;

  const AuthResponseEntity({required this.user, required this.token});
}
