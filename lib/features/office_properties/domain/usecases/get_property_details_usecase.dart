import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/office_properties/domain/repositories/office_properties_repository.dart';
import 'package:dartz/dartz.dart';
import '../entities/property_details_response_entity.dart';

class GetPropertyDetailsUseCase {
  final OfficePropertiesRepository repository;

  GetPropertyDetailsUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsResponseEntity>> call({
    required int propertyId,
  }) {
    return repository.getPropertyDetails(propertyId: propertyId);
  }
}
