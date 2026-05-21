import 'package:equatable/equatable.dart';
import '../../domain/entities/office_info_entity.dart';

abstract class OfficeInfoState extends Equatable {
  const OfficeInfoState();

  @override
  List<Object?> get props => [];
}

class OfficeInfoInitial extends OfficeInfoState {
  const OfficeInfoInitial();
}

class OfficeInfoLoading extends OfficeInfoState {
  const OfficeInfoLoading();
}

class OfficeInfoSuccess extends OfficeInfoState {
  final OfficeInfoEntity officeInfo;

  const OfficeInfoSuccess({required this.officeInfo});

  @override
  List<Object?> get props => [officeInfo];
}

class OfficeInfoError extends OfficeInfoState {
  final String message;

  const OfficeInfoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OfficeInfoUpdating extends OfficeInfoState {
  const OfficeInfoUpdating();
}

class OfficeInfoUpdateSuccess extends OfficeInfoState {
  final OfficeInfoEntity officeInfo;
  final String message;

  const OfficeInfoUpdateSuccess({
    required this.officeInfo,
    required this.message,
  });

  @override
  List<Object?> get props => [officeInfo, message];
}

class OfficeInfoUpdateError extends OfficeInfoState {
  final String message;

  const OfficeInfoUpdateError({required this.message});

  @override
  List<Object?> get props => [message];
}
