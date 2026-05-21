import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import '../entities/office_info_entity.dart';
import '../repositories/office_info_repository.dart';

class UpdateOfficeInfoUseCase {
  final OfficeInfoRepository repository;

  UpdateOfficeInfoUseCase(this.repository);

  Future<Either<Failure, OfficeInfoEntity>> call(
    Map<String, dynamic> updateData,
  ) async {
    return await repository.updateOfficeInfo(updateData);
  }
}
