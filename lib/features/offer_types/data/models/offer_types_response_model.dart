import 'package:dalil_alaqar/features/offer_types/data/models/offer_type_model.dart';
import 'package:dalil_alaqar/features/offer_types/domain/entities/offer_types_response_entity.dart';

class OfferTypesResponseModel extends OfferTypesResponseEntity {
  OfferTypesResponseModel({
    required super.success,
    required super.message,
    required super.offerTypes,
  });

  factory OfferTypesResponseModel.fromJson(Map<String, dynamic> json) {
    return OfferTypesResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      offerTypes:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) => OfferTypeModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': offerTypes
          .map((type) => (type as OfferTypeModel).toJson())
          .toList(),
    };
  }
}
