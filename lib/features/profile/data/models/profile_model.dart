import '../../domain/entities/profile_entity.dart';
import 'office_model.dart';
import 'profile_user_model.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({required super.user, required super.office});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      user: ProfileUserModel.fromJson(json['user'] as Map<String, dynamic>),
      office: OfficeModel.fromJson(json['office'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': (user as ProfileUserModel).toJson(),
      'office': (office as OfficeModel).toJson(),
    };
  }
}
