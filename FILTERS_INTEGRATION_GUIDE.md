# Property & Offer Types Filters - Complete Integration Guide

This guide shows how to integrate both Property Types and Offer Types filters into your properties screen.

## 📦 What's Been Created

Two complete features following Clean Architecture:

### Property Types Feature
- **Endpoint:** `public/data/property-types`
- **Count:** 12 types (شقة, منزل, فيلا, etc.)
- **Icons:** Emoji icons (🏢, 🏠, 🏡, etc.)
- **Location:** `lib/features/property_types/`

### Offer Types Feature
- **Endpoint:** `public/data/offer-types`
- **Count:** 4 types (للبيع, للإيجار, للبيع أو الإيجار, للاستثمار)
- **Icons:** Material Design icons (dynamically assigned)
- **Location:** `lib/features/offer_types/`

## 🚀 Quick Setup (5 Steps)

### Step 1: Add Both Endpoints ✅

Already added to `lib/core/databases/api/end_points.dart`:

```dart
static const String propertyTypes = "public/data/property-types";
static const String offerTypes = "public/data/offer-types";
```

### Step 2: Set Up Dependency Injection

Add to your DI setup file:

```dart
import 'package:dalil_alaqar/features/property_types/data/datasources/property_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/property_types/data/repositories/property_types_repository_impl.dart';
import 'package:dalil_alaqar/features/property_types/domain/repositories/property_types_repository.dart';
import 'package:dalil_alaqar/features/property_types/domain/usecases/get_property_types_usecase.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';

import 'package:dalil_alaqar/features/offer_types/data/datasources/offer_types_remote_data_source.dart';
import 'package:dalil_alaqar/features/offer_types/data/repositories/offer_types_repository_impl.dart';
import 'package:dalil_alaqar/features/offer_types/domain/repositories/offer_types_repository.dart';
import 'package:dalil_alaqar/features/offer_types/domain/usecases/get_offer_types_usecase.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_cubit.dart';

void setupFiltersInjection() {
  // Property Types
  sl.registerLazySingleton<PropertyTypesRemoteDataSource>(
    () => PropertyTypesRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<PropertyTypesRepository>(
    () => PropertyTypesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetPropertyTypesUseCase(repository: sl()));
  sl.registerFactory(() => PropertyTypesCubit(getPropertyTypesUseCase: sl()));

  // Offer Types
  sl.registerLazySingleton<OfferTypesRemoteDataSource>(
    () => OfferTypesRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<OfferTypesRepository>(
    () => OfferTypesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetOfferTypesUseCase(repository: sl()));
  sl.registerFactory(() => OfferTypesCubit(getOfferTypesUseCase: sl()));
}
```

### Step 3: Add BlocProviders to Your App

```dart
MultiBlocProvider(
  providers: [
    // ... existing providers
    BlocProvider<PropertyTypesCubit>(
      create: (context) => sl<PropertyTypesCubit>()..getPropertyTypes(),
    ),
    BlocProvider<OfferTypesCubit>(
      create: (context) => sl<OfferTypesCubit>()..getOfferTypes(),
    ),
  ],
  child: YourApp(),
)
```

### Step 4: Update Properties Cubit

Add filter parameters to your `PropertiesCubit`:

```dart
// In properties_cubit.dart
Future<void> getProperties({
  int? propertyTypeId,
  int? offerTypeId,
  bool refresh = false,
}) async {
  // Your existing logic with new parameters
  final params = PropertiesParams(
    page: refresh ? 1 : _currentPage,
    perPage: _perPage,
    propertyTypeId: propertyTypeId,
    offerTypeId: offerTypeId,
  );
  
  final result = await getPropertiesUseCase(params);
  // ... rest of your logic
}
```

### Step 5: Add Filters to Properties Screen

Create a complete filter section:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_cubit.dart';
import 'package:dalil_alaqar/features/property_types/presentation/cubit/property_types_state.dart';
import 'package:dalil_alaqar/features/property_types/presentation/widgets/property_type_filter_chip.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_cubit.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/cubit/offer_types_state.dart';
import 'package:dalil_alaqar/features/offer_types/presentation/widgets/offer_type_filter_chip.dart';
import 'package:dalil_alaqar/features/properties/presentation/cubit/properties_cubit.dart';

class PropertiesScreenWithFilters extends StatefulWidget {
  const PropertiesScreenWithFilters({super.key});

  @override
  State<PropertiesScreenWithFilters> createState() =>
      _PropertiesScreenWithFiltersState();
}

class _PropertiesScreenWithFiltersState
    extends State<PropertiesScreenWithFilters> {
  int? selectedPropertyTypeId;
  int? selectedOfferTypeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العقارات'),
        actions: [
          // Clear filters button
          if (selectedPropertyTypeId != null || selectedOfferTypeId != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _clearFilters,
              tooltip: 'مسح الفلاتر',
            ),
        ],
      ),
      body: Column(
        children: [
          // Filters Section
          Container(
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Offer Types Filter
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    'نوع العرض:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BlocBuilder<OfferTypesCubit, OfferTypesState>(
                  builder: (context, state) {
                    if (state is OfferTypesSuccess) {
                      return SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.response.offerTypes.length,
                          itemBuilder: (context, index) {
                            final type = state.response.offerTypes[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: OfferTypeFilterChip(
                                offerType: type,
                                isSelected: selectedOfferTypeId == type.id,
                                onTap: () => _selectOfferType(type.id),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 8),
                // Property Types Filter
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'نوع العقار:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                BlocBuilder<PropertyTypesCubit, PropertyTypesState>(
                  builder: (context, state) {
                    if (state is PropertyTypesSuccess) {
                      return SizedBox(
                        height: 50,
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
                                isSelected: selectedPropertyTypeId == type.id,
                                onTap: () => _selectPropertyType(type.id),
                              ),
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Properties List
          Expanded(
            child: PropertiesMobileLayout(),
          ),
        ],
      ),
    );
  }

  void _selectOfferType(int typeId) {
    setState(() {
      if (selectedOfferTypeId == typeId) {
        selectedOfferTypeId = null;
      } else {
        selectedOfferTypeId = typeId;
      }
    });
    _applyFilters();
  }

  void _selectPropertyType(int typeId) {
    setState(() {
      if (selectedPropertyTypeId == typeId) {
        selectedPropertyTypeId = null;
      } else {
        selectedPropertyTypeId = typeId;
      }
    });
    _applyFilters();
  }

  void _applyFilters() {
    context.read<PropertiesCubit>().getProperties(
          propertyTypeId: selectedPropertyTypeId,
          offerTypeId: selectedOfferTypeId,
          refresh: true,
        );
  }

  void _clearFilters() {
    setState(() {
      selectedPropertyTypeId = null;
      selectedOfferTypeId = null;
    });
    _applyFilters();
  }
}
```

## 🎨 UI Design Patterns

### Pattern 1: Horizontal Scrollable Chips (Recommended)

```dart
// Offer types in a horizontal list
SizedBox(
  height: 50,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: offerTypes.length,
    itemBuilder: (context, index) {
      return OfferTypeFilterChip(...);
    },
  ),
)
```

### Pattern 2: Wrap Layout

```dart
// Property types in a wrap
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: propertyTypes.map((type) {
    return PropertyTypeFilterChip(...);
  }).toList(),
)
```

### Pattern 3: Bottom Sheet Filter

```dart
void _showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('الفلاتر', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 16),
                // Offer types section
                const Text('نوع العرض:'),
                BlocBuilder<OfferTypesCubit, OfferTypesState>(...),
                const SizedBox(height: 16),
                // Property types section
                const Text('نوع العقار:'),
                BlocBuilder<PropertyTypesCubit, PropertyTypesState>(...),
                const SizedBox(height: 24),
                // Apply button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyFilters();
                  },
                  child: const Text('تطبيق الفلاتر'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
```

## 📊 Filter State Management

### Option 1: Local State (Simple)

```dart
class _PropertiesScreenState extends State<PropertiesScreen> {
  int? selectedPropertyTypeId;
  int? selectedOfferTypeId;
  
  // Use setState to update
}
```

### Option 2: Cubit State (Advanced)

Create a `FiltersCubit` to manage filter state:

```dart
class FiltersCubit extends Cubit<FiltersState> {
  FiltersCubit() : super(FiltersState());

  void selectPropertyType(int? id) {
    emit(state.copyWith(propertyTypeId: id));
  }

  void selectOfferType(int? id) {
    emit(state.copyWith(offerTypeId: id));
  }

  void clearFilters() {
    emit(FiltersState());
  }
}

class FiltersState {
  final int? propertyTypeId;
  final int? offerTypeId;

  FiltersState({this.propertyTypeId, this.offerTypeId});

  FiltersState copyWith({int? propertyTypeId, int? offerTypeId}) {
    return FiltersState(
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      offerTypeId: offerTypeId ?? this.offerTypeId,
    );
  }
}
```

## 🔍 Advanced Features

### 1. Filter Count Badge

Show how many filters are active:

```dart
AppBar(
  title: const Text('العقارات'),
  actions: [
    Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterBottomSheet,
        ),
        if (_activeFiltersCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_activeFiltersCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    ),
  ],
)

int get _activeFiltersCount {
  int count = 0;
  if (selectedPropertyTypeId != null) count++;
  if (selectedOfferTypeId != null) count++;
  return count;
}
```

### 2. Save Filter Preferences

Save user's last selected filters:

```dart
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _saveFilters() async {
  final prefs = await SharedPreferences.getInstance();
  if (selectedPropertyTypeId != null) {
    await prefs.setInt('property_type_id', selectedPropertyTypeId!);
  }
  if (selectedOfferTypeId != null) {
    await prefs.setInt('offer_type_id', selectedOfferTypeId!);
  }
}

Future<void> _loadFilters() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    selectedPropertyTypeId = prefs.getInt('property_type_id');
    selectedOfferTypeId = prefs.getInt('offer_type_id');
  });
  if (selectedPropertyTypeId != null || selectedOfferTypeId != null) {
    _applyFilters();
  }
}
```

### 3. Filter Animation

Add smooth transitions:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  height: _showFilters ? 200 : 0,
  child: _buildFiltersSection(),
)
```

## 🧪 Testing

### Test Both Features

```dart
void main() {
  testWidgets('Filters work correctly', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // Test offer type selection
    await tester.tap(find.text('للبيع'));
    await tester.pump();
    
    // Test property type selection
    await tester.tap(find.text('شقة'));
    await tester.pump();
    
    // Verify filters are applied
    expect(find.byType(PropertyCard), findsWidgets);
  });
}
```

## 📱 Example Screens

Both features include example screens:
- `PropertyTypesExampleScreen` - Shows all property types
- `OfferTypesExampleScreen` - Shows all offer types

Run them to see the features in action!

## 🎯 Best Practices

1. **Load filters early**: Load both when app starts
2. **Show loading states**: Display skeleton loaders
3. **Handle errors gracefully**: Show retry buttons
4. **Persist selections**: Save user preferences
5. **Clear filters easily**: Provide clear all button
6. **Show active filters**: Use badges or highlights
7. **Optimize performance**: Cache filter data
8. **Test thoroughly**: Test all combinations

## 📚 Documentation

Each feature has comprehensive documentation:

### Property Types
- `lib/features/property_types/README.md`
- `lib/features/property_types/QUICK_START.md`
- `lib/features/property_types/INTEGRATION_GUIDE.md`
- `lib/features/property_types/ARCHITECTURE.md`

### Offer Types
- `lib/features/offer_types/README.md`
- `lib/features/offer_types/QUICK_START.md`

## ✅ Integration Checklist

- [ ] Add dependency injection for both features
- [ ] Add BlocProviders to app
- [ ] Update PropertiesCubit to accept filter parameters
- [ ] Add filter UI to properties screen
- [ ] Test offer type filtering
- [ ] Test property type filtering
- [ ] Test combined filtering
- [ ] Test clear filters functionality
- [ ] Test error handling
- [ ] Test loading states

---

**You're all set!** Both features are ready to use. Just follow the 5 steps above and you'll have a fully functional filtering system. 🎉
