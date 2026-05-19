import '../../domain/entities/promotions_response_entity.dart';
import 'promotion_model.dart';

class PromotionsResponseModel extends PromotionsResponseEntity {
  const PromotionsResponseModel({
    required super.success,
    required super.message,
    required super.data,
  });

  factory PromotionsResponseModel.fromJson(Map<String, dynamic> json) {
    return PromotionsResponseModel(
      success: (json['success'] as bool?) ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PromotionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
