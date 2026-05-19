import 'package:dalil_alaqar/features/neighborhoods/domain/entities/neighborhoods_response_entity.dart';

abstract class NeighborhoodsState {}

class NeighborhoodsInitial extends NeighborhoodsState {}

class NeighborhoodsLoading extends NeighborhoodsState {}

class NeighborhoodsSuccess extends NeighborhoodsState {
  final NeighborhoodsResponseEntity response;
  final int districtId;

  NeighborhoodsSuccess({required this.response, required this.districtId});
}

class NeighborhoodsError extends NeighborhoodsState {
  final String message;

  NeighborhoodsError({required this.message});
}
