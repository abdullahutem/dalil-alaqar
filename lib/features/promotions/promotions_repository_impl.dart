import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/promotions_response_entity.dart';
import '../../domain/repositories/promotions_repository.dart';
import '../datasources/promotions_remote_data_source.dart';

class PromotionsRepositoryImpl implements PromotionsRepository {
  final PromotionsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PromotionsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PromotionsResponseEntity>> getPromotions() async {
    if (!await networkInfo.isConnected) {
      return Left(ConnectionFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
    try {
      final result = await remoteDataSource.getPromotions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
