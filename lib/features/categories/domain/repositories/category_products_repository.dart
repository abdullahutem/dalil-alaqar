import 'package:dartz/dartz.dart';
import 'package:food_delivery/core/errors/failure.dart';
import 'package:food_delivery/features/categories/domain/entities/category_products_entity.dart';

abstract class CategoryProductsRepository {
  Future<Either<Failure, CategoryProductsEntity>> getCategoryProducts(
    int categoryId,
  );
}
