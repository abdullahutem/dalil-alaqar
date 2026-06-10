import 'package:get_it/get_it.dart';
import '../../../core/database/local/database_helper.dart';
import '../data/datasources/categories_local_data_source.dart';
import '../data/datasources/categories_remote_data_source.dart';
import '../data/repositories/categories_repository_impl.dart';
import '../domain/repositories/categories_repository.dart';
import '../domain/usecases/get_categories.dart';
import '../presentation/cubit/categories_cubit.dart';

final sl = GetIt.instance;

Future<void> initCategoriesInjection() async {
  // Cubit
  sl.registerFactory(() => CategoriesCubit(getCategories: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetCategories(repository: sl()));

  // Repository
  sl.registerLazySingleton<CategoriesRepository>(
    () => CategoriesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CategoriesRemoteDataSource>(
    () => CategoriesRemoteDataSource(api: sl()),
  );

  sl.registerLazySingleton<CategoriesLocalDataSource>(
    () => CategoriesLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Database helper (register if not already registered globally)
  if (!sl.isRegistered<DatabaseHelper>()) {
    sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  }
}
