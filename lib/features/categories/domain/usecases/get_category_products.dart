import 'package:dartz/dartz.dart';
import 'package:food_delivery/core/errors/failure.dart';
import 'package:food_delivery/features/categories/domain/entities/category_products_entity.dart';
import 'package:food_delivery/features/categories/domain/repositories/category_products_repository.dart';

class GetCategoryProducts {
  final CategoryProductsRepository repository;

  GetCategoryProducts({required this.repository});

  Future<Either<Failure, CategoryProductsEntity>> call(int categoryId) {
    return repository.getCategoryProducts(categoryId);
  }
}
