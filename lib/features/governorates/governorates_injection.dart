// Dependency Injection Setup for Governorates Feature
//
// This file contains the dependency injection setup for the governorates feature.
// Add these registrations to your main dependency injection container.

/*
import 'package:get_it/get_it.dart';
import 'package:dalil_alaqar/features/governorates/data/datasources/governorates_remote_data_source.dart';
import 'package:dalil_alaqar/features/governorates/data/repositories/governorates_repository_impl.dart';
import 'package:dalil_alaqar/features/governorates/domain/repositories/governorates_repository.dart';
import 'package:dalil_alaqar/features/governorates/domain/usecases/get_governorates_usecase.dart';
import 'package:dalil_alaqar/features/governorates/presentation/cubit/governorates_cubit.dart';

final sl = GetIt.instance;

void setupGovernoratesInjection() {
  // Data Source
  sl.registerLazySingleton<GovernoratesRemoteDataSource>(
    () => GovernoratesRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Repository
  sl.registerLazySingleton<GovernoratesRepository>(
    () => GovernoratesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetGovernoratesUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => GovernoratesCubit(getGovernoratesUseCase: sl()));
}
*/

// Example usage in a widget:

/*
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GovernoratesCubit(
        getGovernoratesUseCase: sl<GetGovernoratesUseCase>(),
      )..getGovernorates(),
      child: GovernoratesExampleScreen(),
    );
  }
}
*/

// Combined with other filters:

/*
MultiBlocProvider(
  providers: [
    BlocProvider<PropertyTypesCubit>(
      create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
    ),
    BlocProvider<OfferTypesCubit>(
      create: (context) => sl<OfferTypesCubit>()..getOfferTypes(),
    ),
    BlocProvider<GovernoratesCubit>(
      create: (context) => sl<GovernoratesCubit>()..getGovernorates(),
    ),
  ],
  child: PropertiesFilterScreen(),
)
*/

// Dropdown usage:

/*
class PropertyFormScreen extends StatefulWidget {
  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  int? selectedGovernorateId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          return DropdownButtonFormField<int>(
            value: selectedGovernorateId,
            decoration: const InputDecoration(
              labelText: 'المحافظة',
              border: OutlineInputBorder(),
            ),
            items: state.response.governorates.map((gov) {
              return DropdownMenuItem<int>(
                value: gov.id,
                child: Text('${gov.nameAr} (${gov.districtsCount} مديرية)'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedGovernorateId = value;
              });
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
*/
