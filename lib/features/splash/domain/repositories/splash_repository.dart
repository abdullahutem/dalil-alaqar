import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/splash/domain/entities/splash_entity.dart';

abstract class SplashRepository {
  Future<Either<Failure, SplashEntity>> getSplashData();
  Future<Either<Failure, bool>> checkFirstLaunch();
}
