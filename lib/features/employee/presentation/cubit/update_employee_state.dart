import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';

abstract class UpdateEmployeeState extends Equatable {
  const UpdateEmployeeState();

  @override
  List<Object?> get props => [];
}

class UpdateEmployeeInitial extends UpdateEmployeeState {
  const UpdateEmployeeInitial();
}

class UpdateEmployeeLoading extends UpdateEmployeeState {
  const UpdateEmployeeLoading();
}

class UpdateEmployeeSuccess extends UpdateEmployeeState {
  final EmployeeEntity employee;
  final String message;

  const UpdateEmployeeSuccess({required this.employee, required this.message});

  @override
  List<Object?> get props => [employee, message];
}

class UpdateEmployeeError extends UpdateEmployeeState {
  final String message;

  const UpdateEmployeeError({required this.message});

  @override
  List<Object?> get props => [message];
}
