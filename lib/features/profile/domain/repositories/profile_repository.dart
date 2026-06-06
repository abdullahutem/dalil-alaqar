import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/profile_entity.dart';
import '../entities/update_profile_params.dart';
import '../entities/updated_user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, UpdatedUserEntity>> updateProfile(
    UpdateProfileParams params,
  );
}
