import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_remote_data_source.dart';
import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';
import 'package:dalil_alaqar/features/districts/domain/repositories/districts_repository.dart';

class DistrictsRepositoryImpl implements DistrictsRepository {
  final DistrictsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DistrictsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DistrictsResponseEntity>> getDistrictsByGovernorate(
    int governorateId,
  ) async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getDistrictsByGovernorate(
          governorateId,
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
