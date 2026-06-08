import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/currencies_response_entity.dart';

abstract class CurrenciesRepository {
  Future<Either<Failure, CurrenciesResponseEntity>> getCurrencies();
}
