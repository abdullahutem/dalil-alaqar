import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';

abstract class EmployeesState extends Equatable {
  const EmployeesState();

  @override
  List<Object?> get props => [];
}

class EmployeesInitial extends EmployeesState {
  const EmployeesInitial();
}

class EmployeesLoading extends EmployeesState {
  const EmployeesLoading();
}

class EmployeesSuccess extends EmployeesState {
  final List<EmployeeEntity> employees;
  final int currentPage;
  final int lastPage;
  final bool isLoadingMore;

  const EmployeesSuccess({
    required this.employees,
    required this.currentPage,
    required this.lastPage,
    this.isLoadingMore = false,
  });

  EmployeesSuccess copyWith({
    List<EmployeeEntity>? employees,
    int? currentPage,
    int? lastPage,
    bool? isLoadingMore,
  }) {
    return EmployeesSuccess(
      employees: employees ?? this.employees,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [employees, currentPage, lastPage, isLoadingMore];
}

class EmployeesError extends EmployeesState {
  final String message;

  const EmployeesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EmployeesLoadMoreError extends EmployeesState {
  final String message;
  final List<EmployeeEntity> employees;
  final int currentPage;
  final int lastPage;

  const EmployeesLoadMoreError({
    required this.message,
    required this.employees,
    required this.currentPage,
    required this.lastPage,
  });

  @override
  List<Object?> get props => [message, employees, currentPage, lastPage];
}
