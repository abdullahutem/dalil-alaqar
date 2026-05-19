# Property Types Feature

This feature implements the property types endpoint integration following Clean Architecture principles.

## API Endpoint

**Endpoint:** `public/data/property-types`  
**Method:** GET  
**Base URL:** `https://dalil-alaqar.codebrains.net/api/`

## Response Structure

```json
{
  "success": true,
  "message": "تم جلب أنواع العقارات بنجاح",
  "data": [
    {
      "id": 1,
      "name": "شقة",
      "icon": "🏢",
      "description": null,
      "order": 1,
      "is_active": true,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:30.000000Z",
      "updated_at": "2026-05-18T10:38:30.000000Z",
      "deleted_at": null
    }
  ]
}
```

## Architecture

The feature follows Clean Architecture with three layers:

### 1. Domain Layer
- **Entities:** `PropertyTypeEntity`, `PropertyTypesResponseEntity`
- **Repository Interface:** `PropertyTypesRepository`
- **Use Cases:** `GetPropertyTypesUseCase`

### 2. Data Layer
- **Models:** `PropertyTypeModel`, `PropertyTypesResponseModel`
- **Data Sources:** `PropertyTypesRemoteDataSource`
- **Repository Implementation:** `PropertyTypesRepositoryImpl`

### 3. Presentation Layer
- **Cubit:** `PropertyTypesCubit`
- **States:** `PropertyTypesState` (Initial, Loading, Success, Error)
- **Widgets:** `PropertyTypeFilterChip`
- **Screens:** `PropertyTypesExampleScreen`

## Setup & Dependency Injection

Add the following to your dependency injection setup (e.g., `get_it` or `provider`):

```dart
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
```

## Usage Examples

### 1. Basic Usage with BlocProvider

```dart
BlocProvider(
  create: (context) => PropertyTypesCubit(
    getPropertyTypesUseCase: sl<GetPropertyTypesUseCase>(),
  )..getPropertyTypes(),
  child: PropertyTypesExampleScreen(),
)
```

### 2. Using in a Filter Widget

```dart
class PropertyFilterWidget extends StatefulWidget {
  @override
  State<PropertyFilterWidget> createState() => _PropertyFilterWidgetState();
}

class _PropertyFilterWidgetState extends State<PropertyFilterWidget> {
  int? selectedPropertyTypeId;

  @override
  void initState() {
    super.initState();
    context.read<PropertyTypesCubit>().getPropertyTypes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
      builder: (context, state) {
        if (state is PropertyTypesSuccess) {
          return Wrap(
            spacing: 8,
            children: state.response.propertyTypes.map((type) {
              return PropertyTypeFilterChip(
                propertyType: type,
                isSelected: selectedPropertyTypeId == type.id,
                onTap: () {
                  setState(() {
                    selectedPropertyTypeId = type.id;
                  });
                  // Apply filter logic here
                },
              );
            }).toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

### 3. Using with Properties List

You can integrate property types as a filter for the properties list:

```dart
// In your properties screen
class PropertiesScreen extends StatefulWidget {
  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  int? selectedPropertyTypeId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Property type filter
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesSuccess) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: state.response.propertyTypes.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PropertyTypeFilterChip(
                        propertyType: type,
                        isSelected: selectedPropertyTypeId == type.id,
                        onTap: () {
                          setState(() {
                            selectedPropertyTypeId = type.id;
                          });
                          // Reload properties with filter
                          context.read<PropertiesCubit>().getProperties(
                            propertyTypeId: selectedPropertyTypeId,
                            refresh: true,
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        // Properties list
        Expanded(
          child: PropertiesMobileLayout(),
        ),
      ],
    );
  }
}
```

## Property Types Available

The API returns the following property types:

1. 🏢 شقة (Apartment)
2. 🏠 منزل (House)
3. 🏡 فيلا (Villa)
4. 🏞️ أرض سكنية (Residential Land)
5. 📐 أرض تجارية (Commercial Land)
6. 🌾 أرض زراعية (Agricultural Land)
7. 🏪 محل تجاري (Commercial Shop)
8. 🏢 مكتب (Office)
9. 🏭 مخزن (Warehouse)
10. 🏗️ عمارة (Building)
11. 🏘️ بيت ريفي (Rural House)
12. 🏖️ شاليه (Chalet)

## Error Handling

The feature includes comprehensive error handling:

- Network connectivity check
- Server error handling
- User-friendly error messages in Arabic
- Retry functionality

## Testing

To test the feature:

1. Run the example screen: `PropertyTypesExampleScreen`
2. Check the loading state
3. Verify the property types are displayed correctly
4. Test the filter chip selection
5. Test error scenarios (no internet, server error)

## Notes

- All property types include an icon emoji for better UX
- Property types are ordered by the `order` field
- Only active property types (`is_active: true`) should be shown in filters
- The feature supports RTL (Right-to-Left) for Arabic text
