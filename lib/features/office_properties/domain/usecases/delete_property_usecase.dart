import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/office_properties_repository.dart';

class DeletePropertyUseCase {
  final OfficePropertiesRepository repository;

  DeletePropertyUseCase(this.repository);

  Future<Either<Failure, String>> call(int propertyId) async {
    return await repository.deleteProperty(propertyId);
  }
}
