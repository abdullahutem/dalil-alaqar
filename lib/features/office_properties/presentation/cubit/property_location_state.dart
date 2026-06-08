import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

abstract class PropertyLocationState extends Equatable {
  const PropertyLocationState();

  @override
  List<Object?> get props => [];
}

class PropertyLocationInitial extends PropertyLocationState {
  const PropertyLocationInitial();
}

class PropertyLocationLoading extends PropertyLocationState {
  const PropertyLocationLoading();
}

class PropertyLocationUpdated extends PropertyLocationState {
  final LatLng position;
  final String? address;

  const PropertyLocationUpdated(this.position, this.address);

  @override
  List<Object?> get props => [position, address];
}

class PropertyLocationPermissionDenied extends PropertyLocationState {
  final String message;

  const PropertyLocationPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

class PropertyLocationError extends PropertyLocationState {
  final String message;

  const PropertyLocationError(this.message);

  @override
  List<Object?> get props => [message];
}
