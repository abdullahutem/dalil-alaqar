import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/office_properties_repository.dart';

class DeletePropertyImageUseCase {
  final OfficePropertiesRepository repository;

  DeletePropertyImageUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required int propertyId,
    required int imageId,
  }) async {
    return await repository.deletePropertyImage(
      propertyId: propertyId,
      imageId: imageId,
    );
  }
}
