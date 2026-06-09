import 'profile_office_entity.dart';
import 'profile_user_entity.dart';

class ProfileEntity {
  final ProfileUserEntity user;
  final ProfileOfficeEntity office;

  const ProfileEntity({required this.user, required this.office});
}
