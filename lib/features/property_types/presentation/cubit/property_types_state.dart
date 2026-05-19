import 'package:dalil_alaqar/features/property_types/domain/entities/property_types_response_entity.dart';

abstract class PropertyTypesState {}

class PropertyTypesInitial extends PropertyTypesState {}

class PropertyTypesLoading extends PropertyTypesState {}

class PropertyTypesSuccess extends PropertyTypesState {
  final PropertyTypesResponseEntity response;

  PropertyTypesSuccess({required this.response});
}

class PropertyTypesError extends PropertyTypesState {
  final String message;

  PropertyTypesError({required this.message});
}
