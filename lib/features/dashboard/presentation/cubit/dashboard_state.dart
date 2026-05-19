import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardSuccess extends DashboardState {
  final DashboardStatsEntity stats;

  DashboardSuccess({required this.stats});
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});
}
