import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offer_types/data/datasources/offer_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_types_response_entity.dart';
import 'package:dalil_alaqar/features/offer_types/domain/repositories/offer_types_repository.dart';

class OfferTypesRepositoryImpl implements OfferTypesRepository {
  final OfferTypesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OfferTypesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfferTypesResponseEntity>> getOfferTypes() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getOfferTypes();
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
