import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/create_property_entity.dart';
import '../entities/property_details_response_entity.dart';
import '../repositories/office_properties_repository.dart';

class CreatePropertyUseCase {
  final OfficePropertiesRepository repository;

  CreatePropertyUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsResponseEntity>> call({
    required CreatePropertyEntity property,
  }) async {
    return await repository.createProperty(property: property);
  }
}
