import 'package:dartz/dartz.dart';

import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/expentions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/params.dart';
import '../../domain/entities/categories_entitiy.dart';
import '../../domain/repositories/categories_repository.dart';

import '../datasources/categories_local_data_source.dart';
import '../datasources/categories_remote_data_source.dart';
import '../models/categories_model.dart';

class CategoriesRepositoryImpl extends CategoriesRepository {
  final NetworkInfo networkInfo;
  final CategoriesRemoteDataSource remoteDataSource;
  final CategoriesLocalDataSource localDataSource;

  CategoriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CategoriesEntity>> getCategories({
    required CategoriesParams params,
  }) async {
    // Check if we're online
    if (await networkInfo.isConnected!) {
      try {
        // Fetch fresh data from network
        final remoteCategories = await remoteDataSource.getCategories(params);

        // Cache the fetched data
        try {
          await localDataSource.cacheCategories(
            remoteCategories.categories.cast<CategoryModel>(),
            append: params.page > 1, // Append for pages > 1, replace for page 1
          );
        } catch (e) {
          // Log cache error but don't fail the request
        }

        return Right(remoteCategories);
      } on ServerException catch (e) {
        // If network fails, try to return cached data (only for first page)
        if (params.page == 1) {
          try {
            final cachedCategories = await localDataSource
                .getCachedCategories();
            if (cachedCategories != null && cachedCategories.isNotEmpty) {
              return Right(
                CategoriesEntity(
                  categories: cachedCategories.cast<CategoryEntity>(),
                  pagination: PaginationEntity(
                    currentPage: 1,
                    lastPage: 999,
                    perPage: cachedCategories.length,
                    total: cachedCategories.length,
                  ),
                ),
              );
            }
          } catch (_) {
            // Cache also failed
          }
        }
        return Left(Failure(errorMessage: e.errorModel.errorMessage));
      }
    } else {
      // We're offline, try to get cached data (only for first page)
      if (params.page == 1) {
        try {
          final cachedCategories = await localDataSource.getCachedCategories();
          if (cachedCategories != null && cachedCategories.isNotEmpty) {
            return Right(
              CategoriesEntity(
                categories: cachedCategories.cast<CategoryEntity>(),
                pagination: PaginationEntity(
                  currentPage: 1,
                  lastPage: 999,
                  perPage: cachedCategories.length,
                  total: cachedCategories.length,
                ),
              ),
            );
          }
        } catch (e) {
          // Cache failed
        }
      }
      return Left(Failure(errorMessage: "لا يوجد اتصال انترنت"));
    }
  }
}
