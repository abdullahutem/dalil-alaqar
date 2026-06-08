import '../../domain/entities/currency_entity.dart';

class CurrencyModel extends CurrencyEntity {
  CurrencyModel({
    required super.id,
    required super.name,
    required super.nameEn,
    required super.code,
    required super.symbol,
    required super.exchangeRate,
    required super.isDefault,
    required super.decimalPlaces,
    required super.position,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      code: json['code'] as String,
      symbol: json['symbol'] as String,
      exchangeRate: json['exchange_rate'] as String,
      isDefault: json['is_default'] as bool,
      decimalPlaces: json['decimal_places'] as int,
      position: json['position'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'code': code,
      'symbol': symbol,
      'exchange_rate': exchangeRate,
      'is_default': isDefault,
      'decimal_places': decimalPlaces,
      'position': position,
    };
  }
}
