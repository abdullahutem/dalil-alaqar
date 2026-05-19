import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';

abstract class GovernoratesRepository {
  Future<Either<Failure, GovernoratesResponseEntity>> getGovernorates();
}
