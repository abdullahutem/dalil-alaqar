import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';

abstract class GovernoratesState {}

class GovernoratesInitial extends GovernoratesState {}

class GovernoratesLoading extends GovernoratesState {}

class GovernoratesSuccess extends GovernoratesState {
  final GovernoratesResponseEntity response;

  GovernoratesSuccess({required this.response});
}

class GovernoratesError extends GovernoratesState {
  final String message;

  GovernoratesError({required this.message});
}
