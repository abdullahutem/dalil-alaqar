import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_types_response_entity.dart';

abstract class OfferTypesState {}

class OfferTypesInitial extends OfferTypesState {}

class OfferTypesLoading extends OfferTypesState {}

class OfferTypesSuccess extends OfferTypesState {
  final OfferTypesResponseEntity response;

  OfferTypesSuccess({required this.response});
}

class OfferTypesError extends OfferTypesState {
  final String message;

  OfferTypesError({required this.message});
}
