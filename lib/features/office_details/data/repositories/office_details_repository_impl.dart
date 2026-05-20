import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_details/data/datasources/office_details_remote_data_source.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/domain/repositories/office_details_repository.dart';

class OfficeDetailsRepositoryImpl implements OfficeDetailsRepository {
  final OfficeDetailsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OfficeDetailsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfficeDetailsEntity>> getOfficeDetails(
    int officeId,
  ) async {
    if (await networkInfo.isConnected!) {
      try {
        final officeDetails = await remoteDataSource.getOfficeDetails(officeId);
        return Right(officeDetails);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(ServerFailure(errMessage: 'No Internet Connection'));
    }
  }
}
