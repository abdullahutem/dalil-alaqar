import 'package:equatable/equatable.dart';
import '../../domain/entities/property_details_entity.dart';

abstract class PropertyDetailsState extends Equatable {
  const PropertyDetailsState();

  @override
  List<Object?> get props => [];
}

class PropertyDetailsInitial extends PropertyDetailsState {
  const PropertyDetailsInitial();
}

class PropertyDetailsLoading extends PropertyDetailsState {
  const PropertyDetailsLoading();
}

class PropertyDetailsSuccess extends PropertyDetailsState {
  final PropertyDetailsEntity property;

  const PropertyDetailsSuccess({required this.property});

  @override
  List<Object?> get props => [property];
}

class PropertyDetailsError extends PropertyDetailsState {
  final String message;

  const PropertyDetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
