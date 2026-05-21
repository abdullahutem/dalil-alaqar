import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_stats_entity.dart';
import '../repositories/office_properties_repository.dart';

class GetPropertyStatsUseCase {
  final OfficePropertiesRepository repository;

  GetPropertyStatsUseCase(this.repository);

  Future<Either<Failure, PropertyStatsEntity>> call() async {
    return await repository.getPropertyStats();
  }
}
