import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/splash/domain/entities/splash_entity.dart';
import 'package:dalil_alaqar/features/splash/domain/repositories/splash_repository.dart';

class GetSplashData {
  final SplashRepository repository;

  GetSplashData({required this.repository});

  Future<Either<Failure, SplashEntity>> call() async {
    return await repository.getSplashData();
  }
}
