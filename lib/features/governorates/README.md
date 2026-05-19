# Governorates Feature

This feature implements the governorates (محافظات) endpoint integration following Clean Architecture principles.

## API Endpoint

**Endpoint:** `public/data/governorates`  
**Method:** GET  
**Base URL:** `https://dalil-alaqar.codebrains.net/api/`

## Response Structure

```json
{
  "success": true,
  "message": "تم جلب المحافظات بنجاح",
  "data": [
    {
      "id": 1,
      "name_ar": "شبوة",
      "name_en": "Shabwah",
      "is_active": true,
      "created_by": null,
      "updated_by": null,
      "created_at": "2026-05-18T10:38:29.000000Z",
      "updated_at": "2026-05-18T10:38:29.000000Z",
      "deleted_at": null,
      "districts_count": 17
    }
  ]
}
```

## Features

✅ **Bilingual Support** - Arabic and English names  
✅ **Districts Count** - Shows number of districts per governorate  
✅ **Search Functionality** - Search in both Arabic and English  
✅ **Filter Chips** - Reusable chip widget with districts count badge  
✅ **Clean Architecture** - Domain, Data, Presentation layers  
✅ **BLoC/Cubit** - State management  
✅ **Error Handling** - Comprehensive error handling with Arabic messages  
✅ **RTL Support** - Full right-to-left support  

## Architecture

### 1. Domain Layer
- **Entities:** `GovernorateEntity`, `GovernoratesResponseEntity`
- **Repository Interface:** `GovernoratesRepository`
- **Use Cases:** `GetGovernoratesUseCase`

### 2. Data Layer
- **Models:** `GovernorateModel`, `GovernoratesResponseModel`
- **Data Sources:** `GovernoratesRemoteDataSource`
- **Repository Implementation:** `GovernoratesRepositoryImpl`

### 3. Presentation Layer
- **Cubit:** `GovernoratesCubit`
- **States:** `GovernoratesState` (Initial, Loading, Success, Error)
- **Widgets:** `GovernorateFilterChip`
- **Screens:** `GovernoratesExampleScreen`

## Setup & Dependency Injection

```dart
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
```

## Usage Examples

### 1. Basic Usage

```dart
BlocProvider(
  create: (context) => GovernoratesCubit(
    getGovernoratesUseCase: sl<GetGovernoratesUseCase>(),
  )..getGovernorates(),
  child: GovernoratesExampleScreen(),
)
```

### 2. Filter Widget

```dart
class LocationFilterWidget extends StatefulWidget {
  @override
  State<LocationFilterWidget> createState() => _LocationFilterWidgetState();
}

class _LocationFilterWidgetState extends State<LocationFilterWidget> {
  int? selectedGovernorateId;

  @override
  void initState() {
    super.initState();
    context.read<GovernoratesCubit>().getGovernorates();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.response.governorates.map((gov) {
              return GovernorateFilterChip(
                governorate: gov,
                isSelected: selectedGovernorateId == gov.id,
                showDistrictsCount: true,
                onTap: () {
                  setState(() {
                    selectedGovernorateId = gov.id;
                  });
                  // Apply filter
                  _filterProperties();
                },
              );
            }).toList(),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _filterProperties() {
    context.read<PropertiesCubit>().getProperties(
      governorateId: selectedGovernorateId,
      refresh: true,
    );
  }
}
```

### 3. Dropdown Selection

```dart
class GovernorateDropdown extends StatelessWidget {
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  const GovernorateDropdown({
    super.key,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          return DropdownButtonFormField<int>(
            value: selectedId,
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
            onChanged: onChanged,
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

### 4. Search with Bilingual Support

```dart
class GovernorateSearchWidget extends StatefulWidget {
  @override
  State<GovernorateSearchWidget> createState() =>
      _GovernorateSearchWidgetState();
}

class _GovernorateSearchWidgetState extends State<GovernorateSearchWidget> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'ابحث عن محافظة...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        BlocBuilder<GovernoratesCubit, GovernoratesState>(
          builder: (context, state) {
            if (state is GovernoratesSuccess) {
              final filtered = state.response.governorates.where((gov) {
                return gov.nameAr.contains(searchQuery) ||
                    gov.nameEn
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
              }).toList();

              return ListView.builder(
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final gov = filtered[index];
                  return ListTile(
                    title: Text(gov.nameAr),
                    subtitle: Text(gov.nameEn),
                    trailing: Text('${gov.districtsCount} مديرية'),
                    onTap: () => _selectGovernorate(gov.id),
                  );
                },
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ],
    );
  }
}
```

## Governorates Available (21)

| ID | Arabic Name | English Name | Districts |
|----|-------------|--------------|-----------|
| 1 | شبوة | Shabwah | 17 |
| 2 | صنعاء | Sanaa | 6 |
| 3 | عدن | Aden | 8 |
| 4 | تعز | Taiz | 4 |
| 5 | حضرموت | Hadramaut | 5 |
| 6 | إب | Ibb | 3 |
| 7 | الحديدة | Al-Hudaydah | 3 |
| 8 | ذمار | Dhamar | 2 |
| 9 | المهرة | Al-Mahrah | 3 |
| 10 | مأرب | Marib | 3 |
| 11 | لحج | Lahij | 2 |
| 12 | أبين | Abyan | 2 |
| 13 | الضالع | Al-Dhale | 2 |
| 14 | البيضاء | Al-Bayda | 2 |
| 15 | عمران | Amran | 2 |
| 16 | صعدة | Saada | 1 |
| 17 | الجوف | Al-Jawf | 1 |
| 18 | حجة | Hajjah | 2 |
| 19 | المحويت | Al-Mahwit | 1 |
| 20 | ريمة | Raymah | 1 |
| 21 | سقطرى | Socotra | 1 |

## Widget Features

### GovernorateFilterChip

```dart
GovernorateFilterChip(
  governorate: governorate,
  isSelected: isSelected,
  showDistrictsCount: true, // Optional: show districts count badge
  onTap: () {},
)
```

Features:
- Location icon
- Arabic name display
- Optional districts count badge
- Selected/unselected states
- Shadow effect when selected
- Rounded corners

## Use Cases

### 1. Property Filtering
Filter properties by governorate location.

### 2. Property Creation
Select governorate when creating/editing a property.

### 3. Location-Based Search
Search properties in specific governorates.

### 4. Statistics Dashboard
Show property counts per governorate.

### 5. Map Integration
Display governorates on a map with property markers.

## Best Practices

1. **Load Early**: Load governorates when app starts
2. **Cache Data**: Cache governorates locally (rarely changes)
3. **Search Support**: Implement bilingual search
4. **Show Districts Count**: Display districts count for context
5. **Sort Options**: Allow sorting by name or districts count
6. **Combine with Districts**: Load districts when governorate is selected

## Integration with Properties

Update your properties cubit to accept governorate filter:

```dart
Future<void> getProperties({
  int? propertyTypeId,
  int? offerTypeId,
  int? governorateId,
  bool refresh = false,
}) async {
  final params = PropertiesParams(
    page: refresh ? 1 : _currentPage,
    perPage: _perPage,
    propertyTypeId: propertyTypeId,
    offerTypeId: offerTypeId,
    governorateId: governorateId,
  );
  
  final result = await getPropertiesUseCase(params);
  // ... rest of logic
}
```

## Sorting Options

### Sort by Name (Arabic)
```dart
governorates.sort((a, b) => a.nameAr.compareTo(b.nameAr));
```

### Sort by Districts Count (Descending)
```dart
governorates.sort((a, b) => b.districtsCount.compareTo(a.districtsCount));
```

### Sort by Name (English)
```dart
governorates.sort((a, b) => a.nameEn.compareTo(b.nameEn));
```

## Caching Example

```dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GovernoratesCache {
  static const String _key = 'cached_governorates';
  
  Future<void> cacheGovernorates(List<GovernorateEntity> governorates) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(
      governorates.map((g) => (g as GovernorateModel).toJson()).toList(),
    );
    await prefs.setString(_key, json);
  }
  
  Future<List<GovernorateModel>?> getCachedGovernorates() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json == null) return null;
    
    final List<dynamic> decoded = jsonDecode(json);
    return decoded.map((item) => GovernorateModel.fromJson(item)).toList();
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

## Notes

- All governorates include bilingual names (Arabic and English)
- Districts count shows the number of districts in each governorate
- Governorates are ordered by the API (can be re-sorted client-side)
- Only active governorates (`is_active: true`) should be shown in filters
- The feature supports RTL (Right-to-Left) for Arabic text
- Search works in both Arabic and English

## Testing

To test the feature:
1. Run the example screen: `GovernoratesExampleScreen`
2. Test the search functionality (Arabic and English)
3. Test filter chip selection
4. Verify districts count display
5. Test error scenarios (no internet, server error)
6. Test bilingual display
