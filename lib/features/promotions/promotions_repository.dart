import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/promotions_response_entity.dart';

abstract class PromotionsRepository {
  Future<Either<Failure, PromotionsResponseEntity>> getPromotions();
}
