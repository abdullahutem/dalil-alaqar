import 'package:dalil_alaqar/features/auth/data/models/user_model.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({required super.user, required super.token});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': (user as UserModel).toJson(), 'token': token};
  }
}
