// Dependency Injection Setup for Offer Types Feature
//
// This file contains the dependency injection setup for the offer types feature.
// Add these registrations to your main dependency injection container.

/*
import 'package:get_it/get_it.dart';
import 'package:dalil_alaqar/features/offer_types/data/datasources/offer_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/offer_types/data/repositories/offer_types_repository_impl.dart';
import 'package:dalil_alaqar/features/offer_types/domain/repositories/offer_types_repository.dart';
import 'package:dalil_alaqar/features/offer_types/domain/usecases/get_offer_types_usecase.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_cubit.dart';

final sl = GetIt.instance;

void setupOfferTypesInjection() {
  // Data Source
  sl.registerLazySingleton<OfferTypesRemoteDataSource>(
    () => OfferTypesRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Repository
  sl.registerLazySingleton<OfferTypesRepository>(
    () => OfferTypesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetOfferTypesUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => OfferTypesCubit(getOfferTypesUseCase: sl()));
}
*/

// Example usage in a widget:

/*
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfferTypesCubit(
        getOfferTypesUseCase: sl<GetOfferTypesUseCase>(),
      )..getOfferTypes(),
      child: OfferTypesExampleScreen(),
    );
  }
}
*/

// Combined with Property Types:

/*
MultiBlocProvider(
  providers: [
    BlocProvider<PropertyTypesCubit>(
      create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
    ),
    BlocProvider<OfferTypesCubit>(
      create: (context) => sl<OfferTypesCubit>()..getOfferTypes(),
    ),
  ],
  child: PropertiesFilterScreen(),
)
*/
