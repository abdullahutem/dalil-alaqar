import 'package:dalil_alaqar/features/properties/domain/entities/properties_response_entity.dart';

abstract class PropertiesState {}

class PropertiesInitial extends PropertiesState {}

class PropertiesLoading extends PropertiesState {}

class PropertiesSuccess extends PropertiesState {
  final PropertiesResponseEntity propertiesResponse;
  final bool isLoadingMore;

  PropertiesSuccess({
    required this.propertiesResponse,
    this.isLoadingMore = false,
  });
}

class PropertiesError extends PropertiesState {
  final String message;

  PropertiesError({required this.message});
}

class PropertiesLoadMoreError extends PropertiesState {
  final PropertiesResponseEntity propertiesResponse;
  final String message;

  PropertiesLoadMoreError({
    required this.propertiesResponse,
    required this.message,
  });
}
