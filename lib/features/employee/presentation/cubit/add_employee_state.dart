import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';

abstract class AddEmployeeState extends Equatable {
  const AddEmployeeState();

  @override
  List<Object?> get props => [];
}

class AddEmployeeInitial extends AddEmployeeState {
  const AddEmployeeInitial();
}

class AddEmployeeLoading extends AddEmployeeState {
  const AddEmployeeLoading();
}

class AddEmployeeSuccess extends AddEmployeeState {
  final EmployeeEntity employee;
  final String message;

  const AddEmployeeSuccess({required this.employee, required this.message});

  @override
  List<Object?> get props => [employee, message];
}

class AddEmployeeError extends AddEmployeeState {
  final String message;

  const AddEmployeeError({required this.message});

  @override
  List<Object?> get props => [message];
}
