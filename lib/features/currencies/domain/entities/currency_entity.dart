class CurrencyEntity {
  final int id;
  final String name;
  final String nameEn;
  final String code;
  final String symbol;
  final String exchangeRate;
  final bool isDefault;
  final int decimalPlaces;
  final String position;

  CurrencyEntity({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.code,
    required this.symbol,
    required this.exchangeRate,
    required this.isDefault,
    required this.decimalPlaces,
    required this.position,
  });
}
