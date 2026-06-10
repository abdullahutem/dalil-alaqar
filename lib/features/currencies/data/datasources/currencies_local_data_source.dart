import 'package:dalil_alaqar/core/databases/local/database_helper.dart';
import 'package:dalil_alaqar/features/currencies/data/models/currency_model.dart';

abstract class CurrenciesLocalDataSource {
  Future<List<CurrencyModel>> getCachedCurrencies();
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);
  Future<void> clearCurrencies();
}

class CurrenciesLocalDataSourceImpl implements CurrenciesLocalDataSource {
  final DatabaseHelper databaseHelper;

  CurrenciesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CurrencyModel>> getCachedCurrencies() async {
    final db = await databaseHelper.database;
    final result = await db.query('currencies', orderBy: 'position ASC');

    return result.map((json) {
      return CurrencyModel(
        id: json['id'] as int,
        name: json['name'] as String,
        nameEn: json['name_en'] as String,
        code: json['code'] as String,
        symbol: json['symbol'] as String,
        exchangeRate: json['exchange_rate'] as String,
        isDefault: (json['is_default'] as int) == 1,
        decimalPlaces: json['decimal_places'] as int,
        position: json['position'] as String,
      );
    }).toList();
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    try {
      final db = await databaseHelper.database;

      print('💾 Caching ${currencies.length} currencies to database');

      // Clear existing currencies
      await db.delete('currencies');

      // Insert new currencies
      final cachedAt = DateTime.now().toIso8601String();
      for (final currency in currencies) {
        print('💾 Inserting currency ${currency.id}: ${currency.name}');
        await db.insert('currencies', {
          'id': currency.id,
          'name': currency.name,
          'name_en': currency.nameEn,
          'code': currency.code,
          'symbol': currency.symbol,
          'exchange_rate': currency.exchangeRate,
          'is_default': currency.isDefault ? 1 : 0,
          'decimal_places': currency.decimalPlaces,
          'position': currency.position,
          'cached_at': cachedAt,
        });
      }

      print('✅ Successfully cached ${currencies.length} currencies');
    } catch (e, stackTrace) {
      print('❌ Error caching currencies: $e');
      print('❌ Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> clearCurrencies() async {
    final db = await databaseHelper.database;
    await db.delete('currencies');
  }
}
