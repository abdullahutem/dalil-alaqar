import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_properties/domain/entities/property_details_response_entity.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/office_properties_response_entity.dart';
import '../../domain/entities/property_stats_entity.dart';
import '../../domain/repositories/office_properties_repository.dart';
import '../datasources/office_properties_remote_data_source.dart';

class OfficePropertiesRepositoryImpl implements OfficePropertiesRepository {
  final OfficePropertiesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OfficePropertiesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OfficePropertiesResponseEntity>> getOfficeProperties({
    required int page,
    required int perPage,
    String? search,
    int? propertyTypeId,
    int? offerTypeId,
    int? governorateId,
    int? districtId,
    int? neighborhoodId,
    double? minPrice,
    double? maxPrice,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getOfficeProperties(
        page: page,
        perPage: perPage,
        search: search,
        propertyTypeId: propertyTypeId,
        offerTypeId: offerTypeId,
        governorateId: governorateId,
        districtId: districtId,
        neighborhoodId: neighborhoodId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PropertyStatsEntity>> getPropertyStats() async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getPropertyStats();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProperty(int propertyId) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final message = await remoteDataSource.deleteProperty(propertyId);
      return Right(message);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, PropertyDetailsResponseEntity>> getPropertyDetails({
    required int propertyId,
  }) async {
    if (!(await networkInfo.isConnected ?? false)) {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }

    try {
      final result = await remoteDataSource.getPropertyDetails(
        propertyId: propertyId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    }
  }
}
