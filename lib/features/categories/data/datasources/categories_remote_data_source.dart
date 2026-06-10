import 'package:food_delivery/core/database/api/api_consumer.dart';
import 'package:food_delivery/core/database/api/end_points.dart';

import '../../../../core/params/params.dart';
import '../models/categories_model.dart';

class CategoriesRemoteDataSource {
  final ApiConsumer api;

  CategoriesRemoteDataSource({required this.api});

  Future<CategoriesModel> getCategories(CategoriesParams params) async {
    final response = await api.get(
      EndPoints.categories,
      queryParameters: {'page': params.page},
    );
    return CategoriesModel.fromJson(response);
  }
}
