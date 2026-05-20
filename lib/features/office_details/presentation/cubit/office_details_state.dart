import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

abstract class OfficeDetailsState {}

class OfficeDetailsInitial extends OfficeDetailsState {}

class OfficeDetailsLoading extends OfficeDetailsState {}

class OfficeDetailsSuccess extends OfficeDetailsState {
  final OfficeDetailsEntity officeDetails;

  OfficeDetailsSuccess({required this.officeDetails});
}

class OfficeDetailsError extends OfficeDetailsState {
  final String message;

  OfficeDetailsError({required this.message});
}
