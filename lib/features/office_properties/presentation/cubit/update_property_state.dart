import '../../domain/entities/property_details_response_entity.dart';

abstract class UpdatePropertyState {}

class UpdatePropertyInitial extends UpdatePropertyState {}

class UpdatePropertyLoading extends UpdatePropertyState {}

class UpdatePropertySuccess extends UpdatePropertyState {
  final PropertyDetailsResponseEntity response;

  UpdatePropertySuccess(this.response);
}

class UpdatePropertyFailure extends UpdatePropertyState {
  final String error;

  UpdatePropertyFailure(this.error);
}
