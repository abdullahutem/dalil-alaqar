import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';

abstract class OfficeDetailsRepository {
  Future<Either<Failure, OfficeDetailsEntity>> getOfficeDetails(int officeId);
}
