import 'package:dartz/dartz.dart';
import 'package:dalil_alaqar/core/connection/network_info.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:dalil_alaqar/features/dashboard/domain/entities/dashboard_stats_entity.dart';
import 'package:dalil_alaqar/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDashboardStats() async {
    if (await networkInfo.isConnected!) {
      try {
        final stats = await remoteDataSource.getDashboardStats();
        return Right(stats);
      } catch (e) {
        return Left(ServerFailure(errMessage: e.toString()));
      }
    } else {
      return Left(ServerFailure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
