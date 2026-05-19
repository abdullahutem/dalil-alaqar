import 'package:dalil_alaqar/features/promotions/domain/entities/promotion_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PromotionsState extends Equatable {
  const PromotionsState();

  @override
  List<Object?> get props => [];
}

class PromotionsInitial extends PromotionsState {
  const PromotionsInitial();
}

class PromotionsLoading extends PromotionsState {
  const PromotionsLoading();
}

class PromotionsSuccess extends PromotionsState {
  final List<PromotionEntity> promotions;

  const PromotionsSuccess({required this.promotions});

  @override
  List<Object?> get props => [promotions];
}

class PromotionsError extends PromotionsState {
  final String message;

  const PromotionsError({required this.message});

  @override
  List<Object?> get props => [message];
}
