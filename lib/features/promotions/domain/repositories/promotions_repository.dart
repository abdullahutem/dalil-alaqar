import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/promotions/domain/entities/promotions_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PromotionsRepository {
  Future<Either<Failure, PromotionsResponseEntity>> getPromotions();
}
