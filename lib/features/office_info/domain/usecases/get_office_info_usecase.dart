import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import '../entities/office_info_entity.dart';
import '../repositories/office_info_repository.dart';

class GetOfficeInfoUseCase {
  final OfficeInfoRepository repository;

  GetOfficeInfoUseCase(this.repository);

  Future<Either<Failure, OfficeInfoEntity>> call() {
    return repository.getOfficeInfo();
  }
}
