import 'currency_entity.dart';

class CurrenciesResponseEntity {
  final bool success;
  final String message;
  final List<CurrencyEntity> currencies;

  CurrenciesResponseEntity({
    required this.success,
    required this.message,
    required this.currencies,
  });
}
