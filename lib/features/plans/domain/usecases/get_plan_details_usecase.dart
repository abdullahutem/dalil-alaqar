import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/plan_entity.dart';
import '../repositories/plans_repository.dart';

class GetPlanDetailsUseCase {
  final PlansRepository repository;

  GetPlanDetailsUseCase({required this.repository});

  Future<Either<Failure, PlanEntity>> call(int planId) async {
    return await repository.getPlanDetails(planId);
  }
}
