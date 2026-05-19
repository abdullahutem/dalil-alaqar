import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_type_entity.dart';

class OfferTypesResponseEntity {
  final bool success;
  final String message;
  final List<OfferTypeEntity> offerTypes;

  OfferTypesResponseEntity({
    required this.success,
    required this.message,
    required this.offerTypes,
  });
}
