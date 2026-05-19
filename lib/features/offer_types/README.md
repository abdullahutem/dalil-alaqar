# Offer Types Feature

This feature implements the offer types endpoint integration following Clean Architecture principles.

## API Endpoint

**Endpoint:** `public/data/offer-types`  
**Method:** GET  
**Base URL:** `https://dalil-alaqar.codebrains.net/api/`

## Response Structure

```json
{
  "success": true,
  "message": "تم جلب أنواع العروض بنجاح",
  "data": [
    {
      "id": 1,
      "name": "للبيع",
      "is_active": true,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:30.000000Z",
      "updated_at": "2026-05-18T10:38:30.000000Z",
      "deleted_at": null
    },
    {
      "id": 2,
      "name": "للإيجار",
      "is_active": true,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:30.000000Z",
      "updated_at": "2026-05-18T10:38:30.000000Z",
      "deleted_at": null
    },
    {
      "id": 3,
      "name": "للبيع أو الإيجار",
      "is_active": true,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:30.000000Z",
      "updated_at": "2026-05-18T10:38:30.000000Z",
      "deleted_at": null
    },
    {
      "id": 4,
      "name": "للاستثمار",
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
- **Entities:** `OfferTypeEntity`, `OfferTypesResponseEntity`
- **Repository Interface:** `OfferTypesRepository`
- **Use Cases:** `GetOfferTypesUseCase`

### 2. Data Layer
- **Models:** `OfferTypeModel`, `OfferTypesResponseModel`
- **Data Sources:** `OfferTypesRemoteDataSource`
- **Repository Implementation:** `OfferTypesRepositoryImpl`

### 3. Presentation Layer
- **Cubit:** `OfferTypesCubit`
- **States:** `OfferTypesState` (Initial, Loading, Success, Error)
- **Widgets:** `OfferTypeFilterChip`
- **Screens:** `OfferTypesExampleScreen`

## Setup & Dependency Injection

Add the following to your dependency injection setup:

```dart
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
```

## Usage Examples

### 1. Basic Usage with BlocProvider

```dart
BlocProvider(
  create: (context) => OfferTypesCubit(
    getOfferTypesUseCase: sl<GetOfferTypesUseCase>(),
  )..getOfferTypes(),
  child: OfferTypesExampleScreen(),
)
```

### 2. Using in a Filter Widget

```dart
class PropertyFilterWidget extends StatefulWidget {
  @override
  State<PropertyFilterWidget> createState() => _PropertyFilterWidgetState();
}

class _PropertyFilterWidgetState extends State<PropertyFilterWidget> {
  int? selectedOfferTypeId;

  @override
  void initState() {
    super.initState();
    context.read<OfferTypesCubit>().getOfferTypes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferTypesCubit, OfferTypesState>(
      builder: (context, state) {
        if (state is OfferTypesSuccess) {
          return Wrap(
            spacing: 8,
            children: state.response.offerTypes.map((type) {
              return OfferTypeFilterChip(
                offerType: type,
                isSelected: selectedOfferTypeId == type.id,
                onTap: () {
                  setState(() {
                    selectedOfferTypeId = type.id;
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

### 3. Combined with Property Types Filter

```dart
class PropertiesFilterScreen extends StatefulWidget {
  @override
  State<PropertiesFilterScreen> createState() => _PropertiesFilterScreenState();
}

class _PropertiesFilterScreenState extends State<PropertiesFilterScreen> {
  int? selectedPropertyTypeId;
  int? selectedOfferTypeId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Offer Type Filter
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'نوع العرض:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        BlocBuilder<OfferTypesCubit, OfferTypesState>(
          builder: (context, state) {
            if (state is OfferTypesSuccess) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: state.response.offerTypes.map((type) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: OfferTypeFilterChip(
                        offerType: type,
                        isSelected: selectedOfferTypeId == type.id,
                        onTap: () {
                          setState(() {
                            selectedOfferTypeId = type.id;
                          });
                          _applyFilters();
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
        const SizedBox(height: 16),
        // Property Type Filter
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'نوع العقار:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
          builder: (context, state) {
            if (state is PropertyTypesSuccess) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.response.propertyTypes.map((type) {
                  return PropertyTypeFilterChip(
                    propertyType: type,
                    isSelected: selectedPropertyTypeId == type.id,
                    onTap: () {
                      setState(() {
                        selectedPropertyTypeId = type.id;
                      });
                      _applyFilters();
                    },
                  );
                }).toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _applyFilters() {
    context.read<PropertiesCubit>().getProperties(
      propertyTypeId: selectedPropertyTypeId,
      offerTypeId: selectedOfferTypeId,
      refresh: true,
    );
  }
}
```

## Offer Types Available

The API returns 4 offer types:

| ID | Name | Icon | Description |
|----|------|------|-------------|
| 1 | للبيع | 🏷️ | For Sale |
| 2 | للإيجار | 🔑 | For Rent |
| 3 | للبيع أو الإيجار | 🏷️🔑 | For Sale or Rent |
| 4 | للاستثمار | 📈 | For Investment |

## Icon Mapping

The `OfferTypeFilterChip` widget automatically assigns icons based on the offer type name:

- **للبيع** (For Sale) → `Icons.sell_outlined`
- **للإيجار** (For Rent) → `Icons.key_outlined`
- **للاستثمار** (For Investment) → `Icons.trending_up_outlined`
- **Default** → `Icons.home_work_outlined`

## Error Handling

The feature includes comprehensive error handling:

- Network connectivity check
- Server error handling
- User-friendly error messages in Arabic
- Retry functionality

## UI Components

### OfferTypeFilterChip

A reusable chip widget with:
- Dynamic icon based on offer type
- Selected/unselected states
- Smooth animations
- Customizable colors
- RTL support

### OfferTypesExampleScreen

A complete example screen featuring:
- Horizontal scrollable filter chips
- Grid view of all offer types
- Color-coded cards
- Selection state management
- Error handling with retry
- Loading states

## Testing

To test the feature:

1. Run the example screen: `OfferTypesExampleScreen`
2. Check the loading state
3. Verify the offer types are displayed correctly
4. Test the filter chip selection
5. Test error scenarios (no internet, server error)

## Integration with Properties

To filter properties by offer type, update your properties API call:

```dart
context.read<PropertiesCubit>().getProperties(
  offerTypeId: selectedOfferTypeId,
  refresh: true,
);
```

Make sure your `PropertiesCubit` accepts an `offerTypeId` parameter.

## Notes

- All offer types include dynamic icons for better UX
- Offer types are displayed in the order returned by the API
- Only active offer types (`is_active: true`) should be shown in filters
- The feature supports RTL (Right-to-Left) for Arabic text
- Icons are Material Design icons, not emojis (unlike property types)

## Customization

### Custom Colors

You can customize the colors in `OfferTypeFilterChip`:

```dart
// In offer_type_filter_chip.dart
Container(
  decoration: BoxDecoration(
    color: isSelected ? YourColors.accent : Colors.white,
    // ...
  ),
)
```

### Custom Icons

To use different icons, modify the `_getIconForOfferType` method:

```dart
IconData _getIconForOfferType(String name) {
  switch (name) {
    case 'للبيع':
      return Icons.shopping_cart;
    case 'للإيجار':
      return Icons.vpn_key;
    // ...
  }
}
```

## Best Practices

1. **Load offer types early**: Load them when the app starts or when the user navigates to the properties screen
2. **Cache the data**: Consider caching offer types locally as they rarely change
3. **Combine with property types**: Use both filters together for better search experience
4. **Show selected count**: Display how many filters are active
5. **Clear filters option**: Provide a way to clear all filters at once

## Example: Clear All Filters

```dart
ElevatedButton(
  onPressed: () {
    setState(() {
      selectedOfferTypeId = null;
      selectedPropertyTypeId = null;
    });
    context.read<PropertiesCubit>().getProperties(refresh: true);
  },
  child: const Text('مسح الفلاتر'),
)
```
