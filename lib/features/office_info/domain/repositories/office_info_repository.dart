import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import '../entities/office_info_entity.dart';

abstract class OfficeInfoRepository {
  Future<Either<Failure, OfficeInfoEntity>> getOfficeInfo();
  Future<Either<Failure, OfficeInfoEntity>> updateOfficeInfo(
    Map<String, dynamic> updateData,
  );
  Future<Either<Failure, Map<String, String>>> uploadOfficeLogo(
    String filePath,
  );
}
