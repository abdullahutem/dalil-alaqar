import 'package:food_delivery/core/database/api/api_consumer.dart';
import 'package:food_delivery/core/database/api/end_points.dart';
import 'package:food_delivery/features/categories/data/models/category_products_model.dart';

class CategoryProductsRemoteDataSource {
  final ApiConsumer api;

  CategoryProductsRemoteDataSource({required this.api});

  Future<CategoryProductsModel> getCategoryProducts(int categoryId) async {
    final response = await api.get("${EndPoints.categories}/$categoryId");
    return CategoryProductsModel.fromJson(response);
  }
}
