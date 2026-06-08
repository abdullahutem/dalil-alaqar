import 'package:dalil_alaqar/core/databases/api/api_consumer.dart';
import 'package:dalil_alaqar/core/databases/api/end_points.dart';
import '../models/currencies_response_model.dart';

abstract class CurrenciesRemoteDataSource {
  Future<CurrenciesResponseModel> getCurrencies();
}

class CurrenciesRemoteDataSourceImpl implements CurrenciesRemoteDataSource {
  final ApiConsumer apiConsumer;

  CurrenciesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CurrenciesResponseModel> getCurrencies() async {
    final response = await apiConsumer.get(EndPoints.currencies);
    return CurrenciesResponseModel.fromJson(response);
  }
}
