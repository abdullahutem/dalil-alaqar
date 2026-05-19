import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_types_response_entity.dart';
import 'package:dalil_alaqar/features/offer_types/domain/repositories/offer_types_repository.dart';

class GetOfferTypesUseCase {
  final OfferTypesRepository repository;

  GetOfferTypesUseCase({required this.repository});

  Future<Either<Failure, OfferTypesResponseEntity>> call() async {
    return await repository.getOfferTypes();
  }
}
