import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/office_properties_repository.dart';

class SetPrimaryImageUseCase {
  final OfficePropertiesRepository repository;

  SetPrimaryImageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required int propertyId,
    required int imageId,
  }) async {
    return await repository.setPrimaryImage(
      propertyId: propertyId,
      imageId: imageId,
    );
  }
}
