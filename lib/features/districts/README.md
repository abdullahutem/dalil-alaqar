# Districts Feature

This feature implements the districts by governorate endpoint integration following Clean Architecture principles. It works in conjunction with the Governorates feature for cascading location selection.

## API Endpoint

**Endpoint:** `public/data/governorates/{governorateId}/districts`  
**Method:** GET  
**Base URL:** `https://dalil-alaqar.codebrains.net/api/`  
**Example:** `public/data/governorates/1/districts`

## Response Structure

```json
{
  "success": true,
  "message": "تم جلب المديريات بنجاح",
  "data": [
    {
      "id": 1,
      "name_ar": "عتق",
      "name_en": "Ataq",
      "is_active": true,
      "governorate_id": 1,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:29.000000Z",
      "updated_at": "2026-05-18T10:38:29.000000Z",
      "deleted_at": null
    }
  ]
}
```

## Features

✅ **Cascading Selection** - Load districts based on selected governorate  
✅ **Bilingual Support** - Arabic and English names  
✅ **Clean Architecture** - Domain, Data, Presentation layers  
✅ **BLoC/Cubit** - State management  
✅ **Error Handling** - Comprehensive error handling with Arabic messages  
✅ **Clear Districts** - Method to clear districts when governorate changes  
✅ **RTL Support** - Full right-to-left support  
✅ **Example Screen** - Complete cascading location selector  

## Architecture

### 1. Domain Layer
- **Entities:** `DistrictEntity`, `DistrictsResponseEntity`
- **Repository Interface:** `DistrictsRepository`
- **Use Cases:** `GetDistrictsByGovernorateUseCase`

### 2. Data Layer
- **Models:** `DistrictModel`, `DistrictsResponseModel`
- **Data Sources:** `DistrictsRemoteDataSource`
- **Repository Implementation:** `DistrictsRepositoryImpl`

### 3. Presentation Layer
- **Cubit:** `DistrictsCubit`
- **States:** `DistrictsState` (Initial, Loading, Success, Error)
- **Widgets:** `DistrictFilterChip`
- **Screens:** `CascadingLocationSelectorScreen`

## Setup & Dependency Injection

```dart
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
```

## Usage Examples

### 1. Cascading Selection

```dart
class LocationSelectorWidget extends StatefulWidget {
  @override
  State<LocationSelectorWidget> createState() => _LocationSelectorWidgetState();
}

class _LocationSelectorWidgetState extends State<LocationSelectorWidget> {
  int? selectedGovernorateId;
  int? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Governorates
        BlocBuilder<GovernoratesCubit, GovernoratesState>(
          builder: (context, state) {
            if (state is GovernoratesSuccess) {
              return Wrap(
                children: state.response.governorates.map((gov) {
                  return GovernorateFilterChip(
                    governorate: gov,
                    isSelected: selectedGovernorateId == gov.id,
                    onTap: () {
                      setState(() {
                        selectedGovernorateId = gov.id;
                        selectedDistrictId = null;
                      });
                      // Load districts
                      context
                          .read<DistrictsCubit>()
                          .getDistrictsByGovernorate(gov.id);
                    },
                  );
                }).toList(),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        // Districts (shown only when governorate is selected)
        if (selectedGovernorateId != null)
          BlocBuilder<DistrictsCubit, DistrictsState>(
            builder: (context, state) {
              if (state is DistrictsSuccess) {
                return Wrap(
                  children: state.response.districts.map((district) {
                    return DistrictFilterChip(
                      district: district,
                      isSelected: selectedDistrictId == district.id,
                      onTap: () {
                        setState(() {
                          selectedDistrictId = district.id;
                        });
                      },
                    );
                  }).toList(),
                );
              }
              if (state is DistrictsLoading) {
                return const CircularProgressIndicator();
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }
}
```

### 2. Dropdown Cascading

```dart
class CascadingDropdowns extends StatefulWidget {
  @override
  State<CascadingDropdowns> createState() => _CascadingDropdownsState();
}

class _CascadingDropdownsState extends State<CascadingDropdowns> {
  int? selectedGovernorateId;
  int? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Governorate Dropdown
        BlocBuilder<GovernoratesCubit, GovernoratesState>(
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
                    child: Text(gov.nameAr),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGovernorateId = value;
                    selectedDistrictId = null;
                  });
                  if (value != null) {
                    context
                        .read<DistrictsCubit>()
                        .getDistrictsByGovernorate(value);
                  } else {
                    context.read<DistrictsCubit>().clearDistricts();
                  }
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
        const SizedBox(height: 16),
        // District Dropdown (enabled only when governorate is selected)
        BlocBuilder<DistrictsCubit, DistrictsState>(
          builder: (context, state) {
            if (state is DistrictsSuccess) {
              return DropdownButtonFormField<int>(
                value: selectedDistrictId,
                decoration: const InputDecoration(
                  labelText: 'المديرية',
                  border: OutlineInputBorder(),
                ),
                items: state.response.districts.map((district) {
                  return DropdownMenuItem<int>(
                    value: district.id,
                    child: Text(district.nameAr),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDistrictId = value;
                  });
                },
              );
            }
            if (state is DistrictsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'المديرية',
                border: OutlineInputBorder(),
              ),
              items: const [],
              onChanged: null, // Disabled
            );
          },
        ),
      ],
    );
  }
}
```

### 3. Bottom Sheet Selector

```dart
Future<Map<String, int?>?> showLocationSelector(BuildContext context) {
  return showModalBottomSheet<Map<String, int?>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<GovernoratesCubit>()),
        BlocProvider.value(value: context.read<DistrictsCubit>()),
      ],
      child: const CascadingLocationSelectorScreen(),
    ),
  );
}

// Usage
final result = await showLocationSelector(context);
if (result != null) {
  final governorateId = result['governorateId'];
  final districtId = result['districtId'];
  // Use the selected IDs
}
```

## Cubit Methods

### getDistrictsByGovernorate(int governorateId)
Loads districts for a specific governorate.

```dart
context.read<DistrictsCubit>().getDistrictsByGovernorate(1);
```

### clearDistricts()
Clears the current districts (useful when governorate changes).

```dart
context.read<DistrictsCubit>().clearDistricts();
```

## Widget Features

### DistrictFilterChip

```dart
DistrictFilterChip(
  district: district,
  isSelected: isSelected,
  onTap: () {},
)
```

Features:
- Place icon
- Arabic name display
- Selected/unselected states
- Smaller size than governorate chips
- Rounded corners

### CascadingLocationSelectorScreen

A complete example screen featuring:
- Governorate selection
- Automatic district loading
- Selected location summary
- Clear selection button
- Apply button
- Error handling with retry
- Loading states

## Use Cases

### 1. Property Filtering
Filter properties by governorate and district.

### 2. Property Creation
Select location when creating/editing a property.

### 3. Advanced Search
Provide detailed location search.

### 4. Location-Based Services
Any feature requiring precise location selection.

## Best Practices

1. **Load Governorates First**: Always load governorates before districts
2. **Clear Districts**: Clear districts when governorate changes
3. **Disable District Selection**: Disable district selection until governorate is selected
4. **Show Loading States**: Show loading indicator when fetching districts
5. **Handle Empty States**: Handle cases where governorate has no districts
6. **Bilingual Support**: Display both Arabic and English names when needed

## Integration with Properties

Update your properties cubit to accept both filters:

```dart
Future<void> getProperties({
  int? propertyTypeId,
  int? offerTypeId,
  int? governorateId,
  int? districtId, // Add this
  bool refresh = false,
}) async {
  final params = PropertiesParams(
    page: refresh ? 1 : _currentPage,
    perPage: _perPage,
    propertyTypeId: propertyTypeId,
    offerTypeId: offerTypeId,
    governorateId: governorateId,
    districtId: districtId,
  );
  
  final result = await getPropertiesUseCase(params);
  // ... rest of logic
}
```

## Example: Complete Filter Flow

```dart
class PropertiesFilterScreen extends StatefulWidget {
  @override
  State<PropertiesFilterScreen> createState() => _PropertiesFilterScreenState();
}

class _PropertiesFilterScreenState extends State<PropertiesFilterScreen> {
  int? selectedOfferTypeId;
  int? selectedPropertyTypeId;
  int? selectedGovernorateId;
  int? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Offer Types
        OfferTypesFilter(
          selectedId: selectedOfferTypeId,
          onSelected: (id) {
            setState(() => selectedOfferTypeId = id);
            _applyFilters();
          },
        ),
        // Property Types
        PropertyTypesFilter(
          selectedId: selectedPropertyTypeId,
          onSelected: (id) {
            setState(() => selectedPropertyTypeId = id);
            _applyFilters();
          },
        ),
        // Governorates
        GovernoratesFilter(
          selectedId: selectedGovernorateId,
          onSelected: (id) {
            setState(() {
              selectedGovernorateId = id;
              selectedDistrictId = null;
            });
            if (id != null) {
              context.read<DistrictsCubit>().getDistrictsByGovernorate(id);
            } else {
              context.read<DistrictsCubit>().clearDistricts();
            }
            _applyFilters();
          },
        ),
        // Districts (conditional)
        if (selectedGovernorateId != null)
          DistrictsFilter(
            selectedId: selectedDistrictId,
            onSelected: (id) {
              setState(() => selectedDistrictId = id);
              _applyFilters();
            },
          ),
      ],
    );
  }

  void _applyFilters() {
    context.read<PropertiesCubit>().getProperties(
      offerTypeId: selectedOfferTypeId,
      propertyTypeId: selectedPropertyTypeId,
      governorateId: selectedGovernorateId,
      districtId: selectedDistrictId,
      refresh: true,
    );
  }
}
```

## Error Handling

The feature includes comprehensive error handling:
- Network connectivity check
- Server error handling
- User-friendly error messages in Arabic
- Retry functionality
- Empty state handling
- Automatic clearing when governorate changes

## Notes

- Districts are loaded dynamically based on selected governorate
- All districts include bilingual names (Arabic and English)
- Districts are filtered by governorate_id
- Only active districts (`is_active: true`) should be shown
- The feature supports RTL (Right-to-Left) for Arabic text
- Always clear districts when governorate selection changes
- Disable district selection until governorate is selected

## Testing

To test the feature:
1. Run the example screen: `CascadingLocationSelectorScreen`
2. Select a governorate
3. Verify districts load automatically
4. Test district selection
5. Test changing governorate (districts should clear)
6. Test error scenarios (no internet, server error)
7. Test bilingual display
8. Test clear selection functionality
