import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/promotions_response_entity.dart';
import '../repositories/promotions_repository.dart';

class GetPromotionsUseCase {
  final PromotionsRepository repository;

  GetPromotionsUseCase(this.repository);

  Future<Either<Failure, PromotionsResponseEntity>> call() {
    return repository.getPromotions();
  }
}
