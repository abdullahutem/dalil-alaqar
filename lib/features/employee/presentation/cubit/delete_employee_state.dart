import 'package:equatable/equatable.dart';

abstract class DeleteEmployeeState extends Equatable {
  const DeleteEmployeeState();

  @override
  List<Object?> get props => [];
}

class DeleteEmployeeInitial extends DeleteEmployeeState {
  const DeleteEmployeeInitial();
}

class DeleteEmployeeLoading extends DeleteEmployeeState {
  const DeleteEmployeeLoading();
}

class DeleteEmployeeSuccess extends DeleteEmployeeState {
  final String message;

  const DeleteEmployeeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class DeleteEmployeeError extends DeleteEmployeeState {
  final String message;

  const DeleteEmployeeError({required this.message});

  @override
  List<Object?> get props => [message];
}
