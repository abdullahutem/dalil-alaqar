import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/neighborhoods/data/datasources/neighborhoods_remote_data_source.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';
import 'package:dalil_alaqar/features/neighborhoods/domain/repositories/neighborhoods_repository.dart';

class NeighborhoodsRepositoryImpl implements NeighborhoodsRepository {
  final NeighborhoodsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NeighborhoodsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NeighborhoodsResponseEntity>>
  getNeighborhoodsByDistrict(int districtId) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getNeighborhoodsByDistrict(
          districtId,
        );
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
