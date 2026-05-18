import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:dalil_alaqar/features/splash/domain/entities/splash_entity.dart';
import 'package:dalil_alaqar/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashLocalDataSource localDataSource;

  SplashRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, SplashEntity>> getSplashData() async {
    try {
      final splashData = await localDataSource.getSplashData();
      return Right(splashData);
    } on CacheExeption catch (e) {
      return Left(CacheFailure(message: e.errorMessage));
    }
  }

  @override
  Future<Either<Failure, bool>> checkFirstLaunch() async {
    try {
      final isFirstLaunch = await localDataSource.checkFirstLaunch();
      return Right(isFirstLaunch);
    } on CacheExeption catch (e) {
      return Left(CacheFailure(message: e.errorMessage));
    }
  }
}
