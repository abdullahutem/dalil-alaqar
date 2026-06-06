import 'office_entity.dart';
import 'profile_user_entity.dart';

class ProfileEntity {
  final ProfileUserEntity user;
  final OfficeEntity office;

  const ProfileEntity({required this.user, required this.office});
}
