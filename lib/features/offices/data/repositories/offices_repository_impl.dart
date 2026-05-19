import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offices/data/datasources/offices_remote_data_source.dart';
import 'package:dalil_alaqar/features/offices/domain/entities/offices_response_entity.dart';
import 'package:dalil_alaqar/features/offices/domain/repositories/offices_repository.dart';
import 'package:dartz/dartz.dart';

class OfficesRepositoryImpl implements OfficesRepository {
  final OfficesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OfficesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfficesResponseEntity>> getOffices({
    required int page,
    required int perPage,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
    try {
      final result = await remoteDataSource.getOffices(
        page: page,
        perPage: perPage,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
