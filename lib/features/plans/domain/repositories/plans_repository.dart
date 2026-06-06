import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/plan_entity.dart';

abstract class PlansRepository {
  Future<Either<Failure, List<PlanEntity>>> getPlans();
  Future<Either<Failure, PlanEntity>> getPlanDetails(int planId);
}
