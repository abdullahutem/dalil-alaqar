import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import '../repositories/office_info_repository.dart';

class UploadOfficeLogoUseCase {
  final OfficeInfoRepository repository;

  UploadOfficeLogoUseCase(this.repository);

  Future<Either<Failure, Map<String, String>>> call(String filePath) async {
    return await repository.uploadOfficeLogo(filePath);
  }
}
