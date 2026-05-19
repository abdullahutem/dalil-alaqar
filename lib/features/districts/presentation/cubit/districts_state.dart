import 'package:dalil_alaqar/features/districts/domain/entities/districts_response_entity.dart';

abstract class DistrictsState {}

class DistrictsInitial extends DistrictsState {}

class DistrictsLoading extends DistrictsState {}

class DistrictsSuccess extends DistrictsState {
  final DistrictsResponseEntity response;
  final int governorateId;

  DistrictsSuccess({required this.response, required this.governorateId});
}

class DistrictsError extends DistrictsState {
  final String message;

  DistrictsError({required this.message});
}
