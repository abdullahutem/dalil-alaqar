import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import '../../domain/entities/currencies_response_entity.dart';
import '../../domain/repositories/currencies_repository.dart';
import '../datasources/currencies_remote_data_source.dart';

class CurrenciesRepositoryImpl implements CurrenciesRepository {
  final CurrenciesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CurrenciesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CurrenciesResponseEntity>> getCurrencies() async {
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getCurrencies();
        return Right(response);
      } catch (e) {
        return Left(ServerFailure(errMessage: e.toString()));
      }
    } else {
      return Left(ServerFailure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
