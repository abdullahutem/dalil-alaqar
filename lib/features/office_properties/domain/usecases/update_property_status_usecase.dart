import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_details_response_entity.dart';
import '../repositories/office_properties_repository.dart';

class UpdatePropertyStatusUseCase {
  final OfficePropertiesRepository repository;

  UpdatePropertyStatusUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsResponseEntity>> call({
    required int propertyId,
    required String status,
  }) async {
    return await repository.updatePropertyStatus(
      propertyId: propertyId,
      status: status,
    );
  }
}
