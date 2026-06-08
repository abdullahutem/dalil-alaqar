import '../../domain/entities/currencies_response_entity.dart';

abstract class CurrenciesState {}

class CurrenciesInitial extends CurrenciesState {}

class CurrenciesLoading extends CurrenciesState {}

class CurrenciesSuccess extends CurrenciesState {
  final CurrenciesResponseEntity response;

  CurrenciesSuccess({required this.response});
}

class CurrenciesError extends CurrenciesState {
  final String message;

  CurrenciesError({required this.message});
}
