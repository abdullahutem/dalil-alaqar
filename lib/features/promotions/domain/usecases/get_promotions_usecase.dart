import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotions_response_entity.dart';
import 'package:dalil_alaqar/features/promotions/domain/repositories/promotions_repository.dart';
import 'package:dartz/dartz.dart';

class GetPromotionsUseCase {
  final PromotionsRepository repository;

  GetPromotionsUseCase(this.repository);

  Future<Either<Failure, PromotionsResponseEntity>> call() {
    return repository.getPromotions();
  }
}
