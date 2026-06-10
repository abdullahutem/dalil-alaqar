// Dependency Injection Setup for Property Types Feature
//
// This file contains the dependency injection setup for the property types feature.
// Add these registrations to your main dependency injection container.
//
// If you're using get_it, add this to your service locator setup:

/*
import 'package:get_it/get_it.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_local_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/repositories/property_types_repository_impl.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';
import 'package:dalil_alaqar/features/property_types/domain/usecases/get_property_types_usecase.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';

final sl = GetIt.instance;

void setupPropertyTypesInjection() {
  // Data Sources
  sl.registerLazySingleton<PropertyTypesRemoteDataSource>(
    () => PropertyTypesRemoteDataSourceImpl(apiConsumer: sl()),
  );
  
  sl.registerLazySingleton<PropertyTypesLocalDataSource>(
    () => PropertyTypesLocalDataSourceImpl(databaseHelper: sl()),
  );

  // Repository
  sl.registerLazySingleton<PropertyTypesRepository>(
    () => PropertyTypesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetPropertyTypesUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => PropertyTypesCubit(getPropertyTypesUseCase: sl()));
}
*/

// If you're using Provider, you can set it up like this:

/*
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

MultiProvider(
  providers: [
    // ... other providers
    
    // Property Types Feature
    Provider<PropertyTypesRemoteDataSource>(
      create: (context) => PropertyTypesRemoteDataSourceImpl(
        apiConsumer: context.read<ApiConsumer>(),
      ),
    ),
    Provider<PropertyTypesLocalDataSource>(
      create: (context) => PropertyTypesLocalDataSourceImpl(
        databaseHelper: context.read<DatabaseHelper>(),
      ),
    ),
    Provider<PropertyTypesRepository>(
      create: (context) => PropertyTypesRepositoryImpl(
        remoteDataSource: context.read<PropertyTypesRemoteDataSource>(),
        localDataSource: context.read<PropertyTypesLocalDataSource>(),
        networkInfo: context.read<NetworkInfo>(),
      ),
    ),
    Provider<GetPropertyTypesUseCase>(
      create: (context) => GetPropertyTypesUseCase(
        repository: context.read<PropertyTypesRepository>(),
      ),
    ),
    BlocProvider<PropertyTypesCubit>(
      create: (context) => PropertyTypesCubit(
        getPropertyTypesUseCase: context.read<GetPropertyTypesUseCase>(),
      ),
    ),
  ],
  child: YourApp(),
)
*/

// Example usage in a widget:

/*
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PropertyTypesCubit(
        getPropertyTypesUseCase: sl<GetPropertyTypesUseCase>(),
      )..getPropertyTypes(),
      child: PropertyTypesExampleScreen(),
    );
  }
}
*/
