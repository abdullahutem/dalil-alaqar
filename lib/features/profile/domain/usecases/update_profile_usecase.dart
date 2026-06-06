import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/update_profile_params.dart';
import '../entities/updated_user_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase({required this.repository});

  Future<Either<Failure, UpdatedUserEntity>> call(
    UpdateProfileParams params,
  ) async {
    return await repository.updateProfile(params);
  }
}
