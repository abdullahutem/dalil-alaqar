import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';
import 'package:dalil_alaqar/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponseEntity>> call({
    required String phoneNumber,
    required String password,
  }) async {
    return await repository.login(phoneNumber: phoneNumber, password: password);
  }
}
