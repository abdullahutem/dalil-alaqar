import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_details_response_entity.dart';
import '../entities/update_property_entity.dart';
import '../repositories/office_properties_repository.dart';

class UpdatePropertyUseCase {
  final OfficePropertiesRepository repository;

  UpdatePropertyUseCase(this.repository);

  Future<Either<Failure, PropertyDetailsResponseEntity>> call({
    required UpdatePropertyEntity property,
  }) async {
    return await repository.updateProperty(property: property);
  }
}
