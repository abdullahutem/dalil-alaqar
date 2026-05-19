# Offer Types - Quick Start Guide

## 🚀 What's Ready

A complete Offer Types feature has been implemented following Clean Architecture.

## 📦 Files Created (12 files)

```
lib/features/offer_types/
├── domain/
│   ├── entities/
│   │   ├── offer_type_entity.dart
│   │   └── offer_types_response_entity.dart
│   ├── repositories/
│   │   └── offer_types_repository.dart
│   └── usecases/
│       └── get_offer_types_usecase.dart
├── data/
│   ├── datasources/
│   │   └── offer_types_remote_data_source.dart
│   ├── models/
│   │   ├── offer_type_model.dart
│   │   └── offer_types_response_model.dart
│   └── repositories/
│       └── offer_types_repository_impl.dart
└── presentation/
    ├── cubit/
    │   ├── offer_types_cubit.dart
    │   └── offer_types_state.dart
    ├── screens/
    │   └── offer_types_example_screen.dart
    └── widgets/
        └── offer_type_filter_chip.dart
```

## ⚡ Quick Integration (3 Steps)

### Step 1: Add Dependency Injection

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

### Step 2: Add BlocProvider

```dart
BlocProvider<OfferTypesCubit>(
  create: (context) => sl<OfferTypesCubit>()..getOfferTypes(),
),
```

### Step 3: Use in UI

```dart
BlocBuilder<OfferTypesCubit, OfferTypesState>(
  builder: (context, state) {
    if (state is OfferTypesSuccess) {
      return Wrap(
        spacing: 8,
        children: state.response.offerTypes.map((type) {
          return OfferTypeFilterChip(
            offerType: type,
            isSelected: selectedId == type.id,
            onTap: () => setState(() => selectedId = type.id),
          );
        }).toList(),
      );
    }
    return const CircularProgressIndicator();
  },
)
```

## 🎯 API Details

**Endpoint:** `public/data/offer-types`  
**Method:** GET  
**Response:** 4 offer types with dynamic icons

## 📱 Offer Types Available

1. 🏷️ **للبيع** (For Sale) - ID: 1
2. 🔑 **للإيجار** (For Rent) - ID: 2
3. 🏷️🔑 **للبيع أو الإيجار** (For Sale or Rent) - ID: 3
4. 📈 **للاستثمار** (For Investment) - ID: 4

## ✨ Features Included

✅ Clean Architecture implementation  
✅ BLoC/Cubit state management  
✅ Dynamic icon assignment  
✅ Error handling with Arabic messages  
✅ Loading states  
✅ Retry functionality  
✅ Reusable filter chip widget  
✅ Example screen with grid layout  
✅ RTL support for Arabic  
✅ Network connectivity check  
✅ Material Design icons  

## 🎨 UI Components

### Filter Chip
- Rounded corners with shadow when selected
- Dynamic icons based on offer type
- Smooth selection animation
- Primary color theme integration

### Example Screen
- Horizontal filter chips
- Grid view with 2 columns
- Color-coded cards
- Status badges (active/inactive)

## 💡 Common Use Cases

### Use Case 1: Filter Properties by Offer Type
Add offer type chips above your properties list.

### Use Case 2: Combined Filters
Use with property types for advanced filtering.

### Use Case 3: Property Creation Form
Use in a dropdown when creating/editing properties.

## 🔧 Integration with Properties

Update your properties cubit to accept offer type filter:

```dart
Future<void> getProperties({
  int? propertyTypeId,
  int? offerTypeId,
  bool refresh = false,
}) async {
  // Add offerTypeId to API call
  final response = await getPropertiesUseCase(
    propertyTypeId: propertyTypeId,
    offerTypeId: offerTypeId,
  );
}
```

## 🎯 Combined Filter Example

```dart
Column(
  children: [
    // Offer Types
    BlocBuilder<OfferTypesCubit, OfferTypesState>(
      builder: (context, state) {
        if (state is OfferTypesSuccess) {
          return Row(
            children: state.response.offerTypes.map((type) {
              return OfferTypeFilterChip(
                offerType: type,
                isSelected: selectedOfferId == type.id,
                onTap: () => _filterProperties(type.id),
              );
            }).toList(),
          );
        }
        return const SizedBox.shrink();
      },
    ),
    // Property Types
    BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
      builder: (context, state) {
        if (state is PropertyTypesSuccess) {
          return Wrap(
            children: state.response.propertyTypes.map((type) {
              return PropertyTypeFilterChip(
                propertyType: type,
                isSelected: selectedPropertyId == type.id,
                onTap: () => _filterProperties(null, type.id),
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
