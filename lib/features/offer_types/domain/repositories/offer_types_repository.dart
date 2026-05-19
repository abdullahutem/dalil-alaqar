import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_types_response_entity.dart';

abstract class OfferTypesRepository {
  Future<Either<Failure, OfferTypesResponseEntity>> getOfferTypes();
}
