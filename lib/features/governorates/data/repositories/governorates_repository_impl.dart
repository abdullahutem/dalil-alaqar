import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/governorates/data/datasources/governorates_remote_data_source.dart';
import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';
import 'package:dalil_alaqar/features/governorates/domain/repositories/governorates_repository.dart';

class GovernoratesRepositoryImpl implements GovernoratesRepository {
  final GovernoratesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GovernoratesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, GovernoratesResponseEntity>> getGovernorates() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getGovernorates();
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
