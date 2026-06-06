import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/plan_entity.dart';
import '../repositories/plans_repository.dart';

class GetPlansUseCase {
  final PlansRepository repository;

  GetPlansUseCase({required this.repository});

  Future<Either<Failure, List<PlanEntity>>> call() async {
    return await repository.getPlans();
  }
}
