import 'package:equatable/equatable.dart';
import '../../domain/entities/property_details_entity.dart';

abstract class CreatePropertyState extends Equatable {
  const CreatePropertyState();

  @override
  List<Object?> get props => [];
}

class CreatePropertyInitial extends CreatePropertyState {
  const CreatePropertyInitial();
}

class CreatePropertyLoading extends CreatePropertyState {
  const CreatePropertyLoading();
}

class CreatePropertySuccess extends CreatePropertyState {
  final PropertyDetailsEntity property;
  final String message;

  const CreatePropertySuccess({required this.property, required this.message});

  @override
  List<Object?> get props => [property, message];
}

class CreatePropertyError extends CreatePropertyState {
  final String message;

  const CreatePropertyError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CreatePropertyValidationError extends CreatePropertyState {
  final Map<String, String> errors;

  const CreatePropertyValidationError({required this.errors});

  @override
  List<Object?> get props => [errors];
}
