import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../entities/categories_entitiy.dart';
import '../repositories/categories_repository.dart';

class GetCategories {
  final CategoriesRepository repository;

  GetCategories({required this.repository});

  Future<Either<Failure, CategoriesEntity>> call({
    required CategoriesParams params,
  }) {
    return repository.getCategories(params: params);
  }
}
