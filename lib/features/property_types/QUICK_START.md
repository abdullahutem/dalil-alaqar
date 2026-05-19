# Property Types - Quick Start Guide

## 🚀 What's Ready

A complete Property Types feature has been implemented following your project's Clean Architecture pattern.

## 📦 Files Created

### Core Files (13 files)
```
lib/features/property_types/
├── domain/
│   ├── entities/
│   │   ├── property_type_entity.dart
│   │   └── property_types_response_entity.dart
│   ├── repositories/
│   │   └── property_types_repository.dart
│   └── usecases/
│       └── get_property_types_usecase.dart
├── data/
│   ├── datasources/
│   │   └── property_types_remote_data_source.dart
│   ├── models/
│   │   ├── property_type_model.dart
│   │   └── property_types_response_model.dart
│   └── repositories/
│       └── property_types_repository_impl.dart
├── presentation/
│   ├── cubit/
│   │   ├── property_types_cubit.dart
│   │   └── property_types_state.dart
│   ├── screens/
│   │   └── property_types_example_screen.dart
│   └── widgets/
│       └── property_type_filter_chip.dart
└── Documentation/
    ├── README.md
    ├── INTEGRATION_GUIDE.md
    ├── QUICK_START.md (this file)
    └── property_types_injection.dart
```

### Updated Files (1 file)
- `lib/core/databases/api/end_points.dart` - Added property types endpoint

## ⚡ Quick Integration (3 Steps)

### Step 1: Add Dependency Injection

Add to your DI setup file:

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

### Step 2: Add BlocProvider

In your app setup:

```dart
BlocProvider<PropertyTypesCubit>(
  create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
),
```

### Step 3: Use in UI

```dart
BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
  builder: (context, state) {
    if (state is PropertyTypesSuccess) {
      return Wrap(
        spacing: 8,
        children: state.response.propertyTypes.map((type) {
          return PropertyTypeFilterChip(
            propertyType: type,
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

**Endpoint:** `public/data/property-types`  
**Method:** GET  
**Response:** 12 property types with icons (🏢, 🏠, 🏡, etc.)

## 📱 Example Screen

Run the example screen to see it in action:

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

## 📖 Full Documentation

- **README.md** - Complete feature overview and usage examples
- **INTEGRATION_GUIDE.md** - Detailed step-by-step integration
- **property_types_injection.dart** - DI setup examples

## ✨ Features Included

✅ Clean Architecture implementation  
✅ BLoC/Cubit state management  
✅ Error handling with Arabic messages  
✅ Loading states  
✅ Retry functionality  
✅ Reusable filter chip widget  
✅ Example screen with full implementation  
✅ RTL support for Arabic  
✅ Network connectivity check  
✅ Comprehensive documentation  

## 🎨 Property Types Available

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

## 🔧 Next Steps

1. Set up dependency injection (see Step 1 above)
2. Add the BlocProvider to your app
3. Test the example screen
4. Integrate into your properties filter
5. Customize the UI to match your design

## 💡 Common Use Cases

### Use Case 1: Filter Properties by Type
Add property type chips above your properties list to filter by type.

### Use Case 2: Property Creation Form
Use property types in a dropdown when creating/editing properties.

### Use Case 3: Search Filters
Include property types in your advanced search/filter dialog.

## 🆘 Need Help?

Check the detailed guides:
- Basic usage → README.md
- Step-by-step integration → INTEGRATION_GUIDE.md
- DI examples → property_types_injection.dart

---

**Ready to use!** All files are created and tested. Just add the dependency injection and you're good to go! 🎉
