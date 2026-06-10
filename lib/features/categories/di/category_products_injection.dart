import 'package:get_it/get_it.dart';
import '../../../core/database/local/database_helper.dart';
import 'package:food_delivery/features/categories/data/datasources/category_products_local_data_source.dart';
import 'package:food_delivery/features/categories/data/datasources/category_products_remote_data_source.dart';
import 'package:food_delivery/features/categories/data/repositories/category_products_repository_impl.dart';
import 'package:food_delivery/features/categories/domain/repositories/category_products_repository.dart';
import 'package:food_delivery/features/categories/domain/usecases/get_category_products.dart';
import 'package:food_delivery/features/categories/presentation/cubit/category_products_cubit.dart';

final sl = GetIt.instance;

Future<void> initCategoryProductsInjection() async {
  // Cubit
  sl.registerFactory(
    () => CategoryProductsCubit(getCategoryProductsUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCategoryProducts(repository: sl()));

  // Repository
  sl.registerLazySingleton<CategoryProductsRepository>(
    () => CategoryProductsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CategoryProductsRemoteDataSource>(
    () => CategoryProductsRemoteDataSource(api: sl()),
  );

  sl.registerLazySingleton<CategoryProductsLocalDataSource>(
    () => CategoryProductsLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Database helper (register if not already registered globally)
  if (!sl.isRegistered<DatabaseHelper>()) {
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  }
}
