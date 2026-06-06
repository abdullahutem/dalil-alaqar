import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../domain/entities/plan_entity.dart';
import '../../domain/repositories/plans_repository.dart';
import '../datasources/plans_remote_data_source.dart';

class PlansRepositoryImpl implements PlansRepository {
  final PlansRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PlansRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PlanEntity>>> getPlans() async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final plans = await remoteDataSource.getPlans();
        return Right(plans);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, PlanEntity>> getPlanDetails(int planId) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final plan = await remoteDataSource.getPlanDetails(planId);
        return Right(plan);
      } on ServerException catch (e) {
        return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
