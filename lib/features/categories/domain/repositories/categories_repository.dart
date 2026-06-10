import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/categories_entitiy.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, CategoriesEntity>> getCategories({
    required CategoriesParams params,
  });
}
