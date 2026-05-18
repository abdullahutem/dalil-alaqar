import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dalil_alaqar/core/errors/expentions.dart';
import 'package:dalil_alaqar/core/errors/failure.dart';
import 'package:dalil_alaqar/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dalil_alaqar/features/auth/domain/entities/auth_response_entity.dart';
import 'package:dalil_alaqar/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    } on DioException catch (e) {
      // Handle specific error response
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Login failed';
        return Left(ServerFailure(errMessage: errorMessage));
      }
      return Left(ServerFailure(errMessage: 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> logout() async {
    try {
      final result = await remoteDataSource.logout();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
    } on DioException catch (e) {
      // Handle specific error response
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        final errorMessage = errorData['error'] ?? 'Logout failed';
        return Left(ServerFailure(errMessage: errorMessage));
      }
      return Left(ServerFailure(errMessage: 'Server error'));
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
