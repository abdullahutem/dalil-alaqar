# Districts - Quick Start Guide

## 🚀 What's Ready

A complete Districts feature with cascading selection (Governorate → Districts) and bilingual support.

## 📦 Files Created (12 files)

```
lib/features/districts/
├── domain/
│   ├── entities/
│   │   ├── district_entity.dart
│   │   └── districts_response_entity.dart
│   ├── repositories/
│   │   └── districts_repository.dart
│   └── usecases/
│       └── get_districts_by_governorate_usecase.dart
├── data/
│   ├── datasources/
│   │   └── districts_remote_data_source.dart
│   ├── models/
│   │   ├── district_model.dart
│   │   └── districts_response_model.dart
│   └── repositories/
│       └── districts_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── districts_cubit.dart
    │   └── districts_state.dart
    ├── screens/
    │   └── cascading_location_selector_screen.dart
    └── widgets/
        └── district_filter_chip.dart
```

## ⚡ Quick Integration (3 Steps)

### Step 1: Add Dependency Injection

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

### Step 2: Add BlocProvider

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<GovernoratesCubit>(
      create: (context) => sl<GovernoratesCubit>()..getGovernorates(),
    ),
    BlocProvider<DistrictsCubit>(
      create: (context) => sl<DistrictsCubit>(),
    ),
  ],
  child: YourApp(),
)
```

### Step 3: Use Cascading Selection

```dart
// When governorate is selected, load its districts
void _onGovernorateSelected(int governorateId) {
  setState(() {
    selectedGovernorateId = governorateId;
    selectedDistrictId = null; // Clear district selection
  });
  // Load districts for this governorate
  context.read<DistrictsCubit>().getDistrictsByGovernorate(governorateId);
}

// Display districts
BlocBuilder<DistrictsCubit, DistrictsState>(
  builder: (context, state) {
    if (state is DistrictsSuccess) {
      return Wrap(
        children: state.response.districts.map((district) {
          return DistrictFilterChip(
            district: district,
            isSelected: selectedDistrictId == district.id,
            onTap: () => setState(() => selectedDistrictId = district.id),
          );
        }).toList(),
      );
    }
    return const CircularProgressIndicator();
  },
)
```

## 🎯 API Details

**Endpoint:** `public/data/governorates/{governorateId}/districts`  
**Method:** GET  
**Example:** `public/data/governorates/1/districts`  
**Response:** Districts for the specified governorate

## ✨ Features Included

✅ Clean Architecture implementation  
✅ BLoC/Cubit state management  
✅ **Cascading selection** (Governorate → Districts)  
✅ **Bilingual support** (Arabic & English)  
✅ **Clear districts** method  
✅ Error handling with Arabic messages  
✅ Loading states  
✅ Retry functionality  
✅ Reusable filter chip widget  
✅ **Complete cascading example screen**  
✅ RTL support for Arabic  
✅ Network connectivity check  

## 🎨 UI Components

### Cascading Location Selector Screen

Features:
- Step-by-step selection (1. Governorate, 2. District)
- Selected location summary at top
- Clear selection button
- Apply button
- Automatic district loading
- Error handling with retry
- Loading states

### Filter Chip
```dart
DistrictFilterChip(
  district: district,
  isSelected: selected,
  onTap: () {},
)
```

## 💡 Common Use Cases

### Use Case 1: Property Location Filter
Cascading location filter for properties.

### Use Case 2: Property Creation Form
Select precise location when creating a property.

### Use Case 3: Advanced Search
Detailed location-based search.

## 🔧 Integration Pattern

```dart
class LocationFilter extends StatefulWidget {
  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  int? selectedGovernorateId;
  int? selectedDistrictId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Step 1: Select Governorate
        Text('1. اختر المحافظة:'),
        GovernoratesFilter(
          onSelected: (govId) {
            setState(() {
              selectedGovernorateId = govId;
              selectedDistrictId = null; // Clear district
            });
            if (govId != null) {
              context.read<DistrictsCubit>().getDistrictsByGovernorate(govId);
            } else {
              context.read<DistrictsCubit>().clearDistricts();
            }
          },
        ),
        
        // Step 2: Select District (shown only when governorate is selected)
        if (selectedGovernorateId != null) ...[
          Text('2. اختر المديرية:'),
          BlocBuilder<DistrictsCubit, DistrictsState>(
            builder: (context, state) {
              if (state is DistrictsSuccess) {
                return DistrictsFilter(
                  districts: state.response.districts,
                  onSelected: (districtId) {
                    setState(() => selectedDistrictId = districtId);
                  },
                );
              }
              if (state is DistrictsLoading) {
                return CircularProgressIndicator();
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ],
    );
  }
}
```

## 🎯 Complete Filter Flow

```
User Flow:
1. User selects governorate (e.g., "شبوة")
   ↓
2. Districts load automatically for that governorate
   ↓
3. User selects district (e.g., "عتق")
   ↓
4. Both selections are applied to filter
```

## 📊 Cubit Methods

### getDistrictsByGovernorate(int governorateId)
```dart
context.read<DistrictsCubit>().getDistrictsByGovernorate(1);
```

### clearDistricts()
```dart
context.read<DistrictsCubit>().clearDistricts();
```

## 🔍 Example: Dropdown Cascading

```dart
// Governorate Dropdown
DropdownButtonFormField<int>(
  value: selectedGovernorateId,
  items: governorates.map((gov) {
    return DropdownMenuItem(value: gov.id, child: Text(gov.nameAr));
  }).toList(),
  onChanged: (govId) {
    setState(() {
      selectedGovernorateId = govId;
      selectedDistrictId = null;
    });
    if (govId != null) {
      context.read<DistrictsCubit>().getDistrictsByGovernorate(govId);
    }
  },
)

// District Dropdown (enabled only when governorate is selected)
BlocBuilder<DistrictsCubit, DistrictsState>(
  builder: (context, state) {
    return DropdownButtonFormField<int>(
      value: selectedDistrictId,
      items: state is DistrictsSuccess
          ? state.response.districts.map((d) {
              return DropdownMenuItem(value: d.id, child: Text(d.nameAr));
            }).toList()
          : [],
      onChanged: selectedGovernorateId != null
          ? (districtId) => setState(() => selectedDistrictId = districtId)
          : null, // Disabled if no governorate selected
    );
  },
)
```

## 📖 Full Documentation

- **README.md** - Complete feature overview and usage examples

## 🆘 Need Help?

Check the README.md for detailed usage examples and integration patterns.

---

**Ready to use!** Works seamlessly with the Governorates feature for complete location selection. 🎉
