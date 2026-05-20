import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_details/domain/entities/office_details_entity.dart';
import 'package:dalil_alaqar/features/office_details/domain/repositories/office_details_repository.dart';

class GetOfficeDetailsUseCase {
  final OfficeDetailsRepository repository;

  GetOfficeDetailsUseCase({required this.repository});

  Future<Either<Failure, OfficeDetailsEntity>> call(int officeId) async {
    return await repository.getOfficeDetails(officeId);
  }
}
