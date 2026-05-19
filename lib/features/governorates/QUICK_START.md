# Governorates - Quick Start Guide

## 🚀 What's Ready

A complete Governorates feature with bilingual support (Arabic/English) and districts count.

## 📦 Files Created (12 files)

```
lib/features/governorates/
├── domain/
│   ├── entities/
│   │   ├── governorate_entity.dart
│   │   └── governorates_response_entity.dart
│   ├── repositories/
│   │   └── governorates_repository.dart
│   └── usecases/
│       └── get_governorates_usecase.dart
├── data/
│   ├── datasources/
│   │   └── governorates_remote_data_source.dart
│   ├── models/
│   │   ├── governorate_model.dart
│   │   └── governorates_response_model.dart
│   └── repositories/
│       └── governorates_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── governorates_cubit.dart
    │   └── governorates_state.dart
    ├── screens/
    │   └── governorates_example_screen.dart
    └── widgets/
        └── governorate_filter_chip.dart
```

## ⚡ Quick Integration (3 Steps)

### Step 1: Add Dependency Injection

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

### Step 2: Add BlocProvider

```dart
BlocProvider<GovernoratesCubit>(
  create: (context) => sl<GovernoratesCubit>()..getGovernorates(),
),
```

### Step 3: Use in UI

```dart
BlocBuilder<GovernoratesCubit, GovernoratesState>(
  builder: (context, state) {
    if (state is GovernoratesSuccess) {
      return Wrap(
        spacing: 8,
        children: state.response.governorates.map((gov) {
          return GovernorateFilterChip(
            governorate: gov,
            isSelected: selectedId == gov.id,
            showDistrictsCount: true,
            onTap: () => setState(() => selectedId = gov.id),
          );
        }).toList(),
      );
    }
    return const CircularProgressIndicator();
  },
)
```

## 🎯 API Details

**Endpoint:** `public/data/governorates`  
**Method:** GET  
**Response:** 21 governorates with bilingual names and districts count

## 📍 Governorates Available (21)

Major governorates with districts count:

1. **شبوة** (Shabwah) - 17 districts
2. **عدن** (Aden) - 8 districts
3. **صنعاء** (Sanaa) - 6 districts
4. **حضرموت** (Hadramaut) - 5 districts
5. **تعز** (Taiz) - 4 districts
6. **إب** (Ibb) - 3 districts
7. **الحديدة** (Al-Hudaydah) - 3 districts
8. And 14 more...

## ✨ Features Included

✅ Clean Architecture implementation  
✅ BLoC/Cubit state management  
✅ **Bilingual support** (Arabic & English)  
✅ **Districts count** display  
✅ **Search functionality** (both languages)  
✅ Error handling with Arabic messages  
✅ Loading states  
✅ Retry functionality  
✅ Reusable filter chip widget  
✅ Example screen with search  
✅ RTL support for Arabic  
✅ Network connectivity check  

## 🎨 UI Components

### Filter Chip with Districts Count
```dart
GovernorateFilterChip(
  governorate: governorate,
  isSelected: selected,
  showDistrictsCount: true, // Shows badge with count
  onTap: () {},
)
```

Features:
- Location icon
- Arabic name
- Districts count badge (optional)
- Selection state
- Shadow when selected

### Example Screen Features
- Search bar (bilingual)
- Filter chips with districts count
- List view with detailed info
- Clear selection button
- Active/inactive status

## 💡 Common Use Cases

### Use Case 1: Location Filter
Add governorate filter to properties screen.

### Use Case 2: Property Creation
Select governorate when creating a property.

### Use Case 3: Search by Location
Search properties in specific governorates.

### Use Case 4: Dropdown Selection
Use in forms as a dropdown.

## 🔧 Integration with Properties

Update your properties cubit:

```dart
Future<void> getProperties({
  int? propertyTypeId,
  int? offerTypeId,
  int? governorateId, // Add this
  bool refresh = false,
}) async {
  // Add governorateId to API call
}
```

## 🔍 Search Example

The feature includes bilingual search:

```dart
// Searches in both Arabic and English
final filtered = governorates.where((gov) {
  return gov.nameAr.contains(searchQuery) ||
      gov.nameEn.toLowerCase().contains(searchQuery.toLowerCase());
}).toList();
```

## 📊 Sorting Options

```dart
// Sort by Arabic name
governorates.sort((a, b) => a.nameAr.compareTo(b.nameAr));

// Sort by districts count (most first)
governorates.sort((a, b) => b.districtsCount.compareTo(a.districtsCount));

// Sort by English name
governorates.sort((a, b) => a.nameEn.compareTo(b.nameEn));
```

## 🎯 Combined Filter Example

```dart
Column(
  children: [
    // Offer Types
    OfferTypesFilter(),
    
    // Property Types
    PropertyTypesFilter(),
    
    // Governorates (Location)
    BlocBuilder<GovernoratesCubit, GovernoratesState>(
      builder: (context, state) {
        if (state is GovernoratesSuccess) {
          return Wrap(
            children: state.response.governorates.map((gov) {
              return GovernorateFilterChip(
                governorate: gov,
                isSelected: selectedGovId == gov.id,
                showDistrictsCount: true,
                onTap: () => _filterByGovernorate(gov.id),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    ),
  ],
)
```

## 📖 Full Documentation

- **README.md** - Complete feature overview and usage examples

## 🆘 Need Help?

Check the README.md for detailed usage examples and integration patterns.

---

**Ready to use!** All files are created and tested. Just add the dependency injection and you're good to go! 🎉
