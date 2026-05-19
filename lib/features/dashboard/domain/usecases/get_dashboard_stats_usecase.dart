import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:dalil_alaqar/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardStatsUseCase {
  final DashboardRepository repository;

  GetDashboardStatsUseCase({required this.repository});

  Future<Either<Failure, DashboardStatsEntity>> call() async {
    return await repository.getDashboardStats();
  }
}
