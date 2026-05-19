import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/data/datasources/properties_remote_data_source.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/repositories/properties_repository.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final PropertiesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PropertiesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PropertiesResponseEntity>> getProperties({
    int page = 1,
    int perPage = 20,
  }) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final result = await remoteDataSource.getProperties(
          page: page,
          perPage: perPage,
        );
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      } on DioException catch (e) {
        return Left(
          ServerFailure(errMessage: e.message ?? 'Network error occurred'),
        );
      } catch (e) {
        return Left(
          ServerFailure(errMessage: 'Unexpected error: ${e.toString()}'),
        );
      }
    } else {
      return Left(
        ServerFailure(
          errMessage: 'No internet connection. Please check your network.',
        ),
      );
    }
  }
}
