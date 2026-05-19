import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';

class PropertyTypesRepositoryImpl implements PropertyTypesRepository {
  final PropertyTypesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PropertyTypesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PropertyTypesResponseEntity>>
  getPropertyTypes() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getPropertyTypes();
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
