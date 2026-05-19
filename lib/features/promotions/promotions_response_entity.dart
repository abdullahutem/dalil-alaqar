import 'promotion_entity.dart';

class PromotionsResponseEntity {
  final bool success;
  final String message;
  final List<PromotionEntity> data;

  const PromotionsResponseEntity({
    required this.success,
    required this.message,
    required this.data,
  });
}
