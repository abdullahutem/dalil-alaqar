import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> login({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, String>> logout();
}
