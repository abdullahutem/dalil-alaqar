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
