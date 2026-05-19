import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/governorates/domain/entities/governorates_response_entity.dart';
import 'package:dalil_alaqar/features/governorates/domain/repositories/governorates_repository.dart';

class GetGovernoratesUseCase {
  final GovernoratesRepository repository;

  GetGovernoratesUseCase({required this.repository});

  Future<Either<Failure, GovernoratesResponseEntity>> call() async {
    return await repository.getGovernorates();
  }
}
