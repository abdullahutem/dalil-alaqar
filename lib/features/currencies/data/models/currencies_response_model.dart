import '../../domain/entities/currencies_response_entity.dart';
import 'currency_model.dart';

class CurrenciesResponseModel extends CurrenciesResponseEntity {
  CurrenciesResponseModel({
    required super.success,
    required super.message,
    required super.currencies,
  });

  factory CurrenciesResponseModel.fromJson(Map<String, dynamic> json) {
    return CurrenciesResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      currencies: (json['data'] as List<dynamic>)
          .map((item) => CurrencyModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': currencies
          .map((currency) => (currency as CurrencyModel).toJson())
          .toList(),
    };
  }
}
