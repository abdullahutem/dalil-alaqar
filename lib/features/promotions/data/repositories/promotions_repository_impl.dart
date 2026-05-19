import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/promotions/data/datasources/promotions_remote_data_source.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotions_response_entity.dart';
import 'package:dalil_alaqar/features/promotions/domain/repositories/promotions_repository.dart';
import 'package:dartz/dartz.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PromotionsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PromotionsResponseEntity>> getPromotions() async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
    try {
      final result = await remoteDataSource.getPromotions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
