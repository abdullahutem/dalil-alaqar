# Property Types Integration Guide

This guide will help you integrate the Property Types feature into your application.

## 📋 What's Been Created

The following files have been created following Clean Architecture:

### Domain Layer
```
lib/features/property_types/domain/
├── entities/
│   ├── property_type_entity.dart
│   └── property_types_response_entity.dart
├── repositories/
│   └── property_types_repository.dart
└── usecases/
    └── get_property_types_usecase.dart
```

### Data Layer
```
lib/features/property_types/data/
├── datasources/
│   └── property_types_remote_data_source.dart
├── models/
│   ├── property_type_model.dart
│   └── property_types_response_model.dart
└── repositories/
    └── property_types_repository_impl.dart
```

### Presentation Layer
```
lib/features/property_types/presentation/
├── cubit/
│   ├── property_types_cubit.dart
│   └── property_types_state.dart
├── screens/
│   └── property_types_example_screen.dart
└── widgets/
    └── property_type_filter_chip.dart
```

### Configuration
```
lib/features/property_types/
├── README.md
├── INTEGRATION_GUIDE.md (this file)
└── property_types_injection.dart
```

## 🔧 Step-by-Step Integration

### Step 1: Update API Endpoints ✅

The endpoint has already been added to `lib/core/databases/api/end_points.dart`:

```dart
static const String propertyTypes = "public/data/property-types";
```

### Step 2: Set Up Dependency Injection

Find your dependency injection setup file (usually in `lib/core/di/` or similar) and add:

```dart
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/repositories/property_types_repository_impl.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';
import 'package:dalil_alaqar/features/property_types/domain/usecases/get_property_types_usecase.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';

// Add to your setup function:
void setupPropertyTypes() {
  // Data Source
  sl.registerLazySingleton<PropertyTypesRemoteDataSource>(
    () => PropertyTypesRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Repository
  sl.registerLazySingleton<PropertyTypesRepository>(
    () => PropertyTypesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use Case
  sl.registerLazySingleton(() => GetPropertyTypesUseCase(repository: sl()));

  // Cubit
  sl.registerFactory(() => PropertyTypesCubit(getPropertyTypesUseCase: sl()));
}
```

### Step 3: Add to Your App's BlocProvider

In your main app file or where you set up BlocProviders:

```dart
MultiBlocProvider(
  providers: [
    // ... existing providers
    BlocProvider<PropertyTypesCubit>(
      create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
    ),
  ],
  child: YourApp(),
)
```

### Step 4: Use in Your UI

#### Option A: As a Filter in Properties Screen

Add property type filters to your properties screen:

```dart
// In properties_mobile_layout.dart or similar
Column(
  children: [
    // Property Type Filter
    BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
      builder: (context, state) {
        if (state is PropertyTypesSuccess) {
          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.response.propertyTypes.length,
              itemBuilder: (context, index) {
                final type = state.response.propertyTypes[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: PropertyTypeFilterChip(
                    propertyType: type,
                    isSelected: selectedTypeId == type.id,
                    onTap: () {
                      setState(() {
                        selectedTypeId = type.id;
                      });
                      // Filter properties by type
                      context.read<PropertiesCubit>().getProperties(
                        propertyTypeId: type.id,
                        refresh: true,
                      );
                    },
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    ),
    // Properties List
    Expanded(
      child: PropertiesMobileLayout(),
    ),
  ],
)
```

#### Option B: Standalone Screen

Navigate to the example screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
      child: const PropertyTypesExampleScreen(),
    ),
  ),
);
```

#### Option C: In a Search/Filter Dialog

```dart
showModalBottomSheet(
  context: context,
  builder: (context) => BlocProvider.value(
    value: context.read<PropertyTypesCubit>(),
    child: BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
      builder: (context, state) {
        if (state is PropertyTypesSuccess) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'اختر نوع العقار',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.propertyTypes.map((type) {
                  return PropertyTypeFilterChip(
                    propertyType: type,
                    isSelected: selectedTypeId == type.id,
                    onTap: () {
                      // Handle selection
                      Navigator.pop(context, type.id);
                    },
                  );
                }).toList(),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    ),
  ),
);
```

## 🎨 Customization

### Customize the Filter Chip

You can modify `PropertyTypeFilterChip` to match your design:

```dart
// Change colors
Container(
  decoration: BoxDecoration(
    color: isSelected ? YourColors.primary : Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  // ...
)
```

### Add Caching

To cache property types locally:

1. Create a local data source:
```dart
abstract class PropertyTypesLocalDataSource {
  Future<PropertyTypesResponseModel> getCachedPropertyTypes();
  Future<void> cachePropertyTypes(PropertyTypesResponseModel types);
}
```

2. Update the repository to check cache first:
```dart
@override
Future<Either<Failure, PropertyTypesResponseEntity>> getPropertyTypes() async {
  try {
    // Try to get from cache first
    final cached = await localDataSource.getCachedPropertyTypes();
    return Right(cached);
  } catch (e) {
    // If cache fails, fetch from remote
    if (await networkInfo.isConnected!) {
      try {
        final response = await remoteDataSource.getPropertyTypes();
        // Cache the response
        await localDataSource.cachePropertyTypes(response);
        return Right(response);
      } on ServerException catch (e) {
        return Left(Failure(errMessage: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
```

## 🧪 Testing

### Test the API Call

```dart
void main() {
  test('should fetch property types successfully', () async {
    // Arrange
    final cubit = PropertyTypesCubit(getPropertyTypesUseCase: mockUseCase);
    
    // Act
    await cubit.getPropertyTypes();
    
    // Assert
    expect(cubit.state, isA<PropertyTypesSuccess>());
  });
}
```

### Manual Testing

1. Run the app
2. Navigate to `PropertyTypesExampleScreen`
3. Verify:
   - Loading indicator appears
   - Property types load successfully
   - Icons display correctly
   - Filter chips are selectable
   - Error handling works (turn off internet)

## 📱 UI Examples

### Property Types in the Response

The API returns 12 property types:

| ID | Name | Icon | Description |
|----|------|------|-------------|
| 1 | شقة | 🏢 | Apartment |
| 2 | منزل | 🏠 | House |
| 3 | فيلا | 🏡 | Villa |
| 4 | أرض سكنية | 🏞️ | Residential Land |
| 5 | أرض تجارية | 📐 | Commercial Land |
| 6 | أرض زراعية | 🌾 | Agricultural Land |
| 7 | محل تجاري | 🏪 | Commercial Shop |
| 8 | مكتب | 🏢 | Office |
| 9 | مخزن | 🏭 | Warehouse |
| 10 | عمارة | 🏗️ | Building |
| 11 | بيت ريفي | 🏘️ | Rural House |
| 12 | شاليه | 🏖️ | Chalet |

## 🔍 Troubleshooting

### Issue: Property types not loading

**Solution:**
1. Check internet connection
2. Verify the API endpoint is correct in `end_points.dart`
3. Check if `ApiConsumer` is properly injected
4. Look at console logs for error messages

### Issue: Icons not displaying

**Solution:**
- Ensure your app supports emoji rendering
- Check if the font supports emoji characters
- The icons are Unicode emojis and should work on all platforms

### Issue: Cubit not found

**Solution:**
- Make sure you've added the dependency injection setup
- Verify `PropertyTypesCubit` is provided in the widget tree
- Check if you're calling `sl<PropertyTypesCubit>()` correctly

## 📚 Additional Resources

- [BLoC Pattern Documentation](https://bloclibrary.dev/)
- [Clean Architecture in Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Dartz Package (Either type)](https://pub.dev/packages/dartz)

## ✅ Checklist

Before considering the integration complete:

- [ ] Dependency injection is set up
- [ ] PropertyTypesCubit is provided in the app
- [ ] API endpoint is configured correctly
- [ ] UI displays property types correctly
- [ ] Filter functionality works
- [ ] Error handling is tested
- [ ] Loading states are handled
- [ ] RTL support is working for Arabic text

## 🤝 Need Help?

If you encounter any issues:
1. Check the example screen implementation
2. Review the README.md file
3. Verify all dependencies are properly injected
4. Check console logs for detailed error messages
