// Dependency Injection Setup for Districts Feature
//
// This file contains the dependency injection setup for the districts feature.
// Add these registrations to your main dependency injection container.

/*
import 'package:get_it/get_it.dart';
import 'package:dalil_alaqar/features/districts/data/datasources/districts_remote_data_source.dart';
import 'package:dalil_alaqar/features/districts/data/repositories/districts_repository_impl.dart';
import 'package:dalil_alaqar/features/districts/domain/repositories/districts_repository.dart';
import 'package:dalil_alaqar/features/districts/domain/usecases/get_districts_by_governorate_usecase.dart';
import 'package:dalil_alaqar/features/districts/presentation/cubit/districts_cubit.dart';

final sl = GetIt.instance;

void setupDistrictsInjection() {
  // Data Source
  sl.registerLazySingleton<DistrictsRemoteDataSource>(
    () => DistrictsRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Repository
  sl.registerLazySingleton<DistrictsRepository>(
    () => DistrictsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(
    () => GetDistrictsByGovernorateUseCase(repository: sl()),
  );

  // Cubit
  sl.registerFactory(
    () => DistrictsCubit(getDistrictsByGovernorateUseCase: sl()),
  );
}
*/

// Combined with Governorates:

/*
MultiBlocProvider(
  providers: [
    // Governorates
    BlocProvider<GovernoratesCubit>(
      create: (context) => sl<GovernoratesCubit>()..getGovernorates(),
    ),
    // Districts
    BlocProvider<DistrictsCubit>(
      create: (context) => sl<DistrictsCubit>(),
    ),
  ],
  child: CascadingLocationSelectorScreen(),
)
*/

// Complete location filter setup:

/*
void setupLocationFiltersInjection() {
  // Governorates
  sl.registerLazySingleton<GovernoratesRemoteDataSource>(
    () => GovernoratesRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<GovernoratesRepository>(
    () => GovernoratesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetGovernoratesUseCase(repository: sl()));
  sl.registerFactory(() => GovernoratesCubit(getGovernoratesUseCase: sl()));

  // Districts
  sl.registerLazySingleton<DistrictsRemoteDataSource>(
    () => DistrictsRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<DistrictsRepository>(
    () => DistrictsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDistrictsByGovernorateUseCase(repository: sl()),
  );
  sl.registerFactory(
    () => DistrictsCubit(getDistrictsByGovernorateUseCase: sl()),
  );
}
*/
