import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/properties/domain/entities/property_details_entity.dart';
import 'package:dalil_alaqar/features/properties/domain/repositories/properties_repository.dart';

class GetPropertyDetailsUseCase {
  final PropertiesRepository repository;

  GetPropertyDetailsUseCase({required this.repository});

  Future<Either<Failure, PropertyDetailsEntity>> call({required int id}) async {
    return await repository.getPropertyDetails(id: id);
  }
}
