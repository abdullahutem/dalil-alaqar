import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';

abstract class PropertyDetailsState {}

class PropertyDetailsInitial extends PropertyDetailsState {}

class PropertyDetailsLoading extends PropertyDetailsState {}

class PropertyDetailsSuccess extends PropertyDetailsState {
  final PropertyDetailsEntity property;

  PropertyDetailsSuccess({required this.property});
}

class PropertyDetailsError extends PropertyDetailsState {
  final String message;

  PropertyDetailsError({required this.message});
}
