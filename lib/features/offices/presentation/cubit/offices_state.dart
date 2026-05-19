import 'package:dalil_alaqar/features/offices/domain/entities/office_entity.dart';
import 'package:equatable/equatable.dart';

abstract class OfficesState extends Equatable {
  const OfficesState();

  @override
  List<Object?> get props => [];
}

class OfficesInitial extends OfficesState {
  const OfficesInitial();
}

class OfficesLoading extends OfficesState {
  const OfficesLoading();
}

class OfficesSuccess extends OfficesState {
  final List<OfficeEntity> offices;
  final bool hasReachedMax;
  final int currentPage;

  const OfficesSuccess({
    required this.offices,
    required this.hasReachedMax,
    required this.currentPage,
  });

  OfficesSuccess copyWith({
    List<OfficeEntity>? offices,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return OfficesSuccess(
      offices: offices ?? this.offices,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [offices, hasReachedMax, currentPage];
}

class OfficesError extends OfficesState {
  final String message;

  const OfficesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OfficesLoadMoreError extends OfficesState {
  final String message;
  final List<OfficeEntity> offices;
  final int currentPage;

  const OfficesLoadMoreError({
    required this.message,
    required this.offices,
    required this.currentPage,
  });

  @override
  List<Object?> get props => [message, offices, currentPage];
}
