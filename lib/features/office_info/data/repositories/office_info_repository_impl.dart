import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import '../../domain/entities/office_info_entity.dart';
import '../../domain/repositories/office_info_repository.dart';
import '../datasources/office_info_remote_data_source.dart';

class OfficeInfoRepositoryImpl implements OfficeInfoRepository {
  final OfficeInfoRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OfficeInfoRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfficeInfoEntity>> getOfficeInfo() async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getOfficeInfo();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, OfficeInfoEntity>> updateOfficeInfo(
    Map<String, dynamic> updateData,
  ) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.updateOfficeInfo(updateData);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
