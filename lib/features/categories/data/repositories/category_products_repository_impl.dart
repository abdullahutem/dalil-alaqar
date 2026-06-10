import 'package:dartz/dartz.dart';
import 'package:food_delivery/core/connection/network_info.dart';
import 'package:food_delivery/core/errors/expentions.dart';
import 'package:food_delivery/core/errors/failure.dart';
import 'package:food_delivery/features/categories/data/datasources/category_products_local_data_source.dart';
import 'package:food_delivery/features/categories/data/datasources/category_products_remote_data_source.dart';
import 'package:food_delivery/features/categories/data/models/category_products_model.dart';
import 'package:food_delivery/features/categories/domain/entities/category_products_entity.dart';
import 'package:food_delivery/features/categories/domain/repositories/category_products_repository.dart';

class CategoryProductsRepositoryImpl extends CategoryProductsRepository {
  final NetworkInfo networkInfo;
  final CategoryProductsRemoteDataSource remoteDataSource;
  final CategoryProductsLocalDataSource localDataSource;

  CategoryProductsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CategoryProductsEntity>> getCategoryProducts(
    int categoryId,
  ) async {
    // Check if we're online
    if (await networkInfo.isConnected!) {
      try {
        // Fetch fresh data from network
        final remoteCategoryProducts = await remoteDataSource
            .getCategoryProducts(categoryId);

        // Cache the fetched data
        try {
          await localDataSource.cacheCategoryProducts(
            categoryId,
            remoteCategoryProducts.products.cast<CategoryProductModel>(),
            append: false,
          );
        } catch (e) {
          // Log cache error but don't fail the request
        }

        return Right(remoteCategoryProducts);
      } on ServerException catch (e) {
        // If network fails, try to return cached data
        try {
          final cachedProducts = await localDataSource
              .getCachedCategoryProducts(categoryId);
          if (cachedProducts != null && cachedProducts.isNotEmpty) {
            return Right(
              CategoryProductsEntity(
                category: CategoryDetailEntity(
                  id: categoryId,
                  name: '',
                  nameAr: '',
                ),
                products: cachedProducts.cast<CategoryProductEntity>(),
                pagination: PaginationEntity(
                  currentPage: 1,
                  lastPage: 999,
                  perPage: cachedProducts.length,
                  total: cachedProducts.length,
                ),
              ),
            );
          }
        } catch (_) {
          // Cache also failed
        }
        return Left(Failure(errorMessage: e.errorModel.errorMessage));
      }
    } else {
      // We're offline, try to get cached data
      try {
        final cachedProducts = await localDataSource.getCachedCategoryProducts(
          categoryId,
        );
        if (cachedProducts != null && cachedProducts.isNotEmpty) {
          return Right(
            CategoryProductsEntity(
              category: CategoryDetailEntity(
                id: categoryId,
                name: '',
                nameAr: '',
              ),
              products: cachedProducts.cast<CategoryProductEntity>(),
              pagination: PaginationEntity(
                currentPage: 1,
                lastPage: 999,
                perPage: cachedProducts.length,
                total: cachedProducts.length,
              ),
            ),
          );
        }
      } catch (e) {
        // Cache failed
      }
      return Left(Failure(errorMessage: "لا يوجد اتصال انترنت"));
    }
  }
}
