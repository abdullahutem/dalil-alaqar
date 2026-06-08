import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/currencies_response_entity.dart';
import '../repositories/currencies_repository.dart';

class GetCurrenciesUseCase {
  final CurrenciesRepository repository;

  GetCurrenciesUseCase({required this.repository});

  Future<Either<Failure, CurrenciesResponseEntity>> call() async {
    return await repository.getCurrencies();
  }
}
