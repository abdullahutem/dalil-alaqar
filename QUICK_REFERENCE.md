# 🚀 Quick Reference Guide

## 📱 How to Use the Advanced Search

### Step 1: Open Properties Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PropertiesScreen(),
  ),
);
```

### Step 2: Tap Search Icon
Look for the search icon (🔍) in the app bar.

### Step 3: Select Filters

#### Text Search
Type keywords like "فيلا", "شقة", etc.

#### Property Type
Select from 12 types:
- 🏢 شقة (Apartment)
- 🏠 منزل (House)
- 🏡 فيلا (Villa)
- 🏞️ أرض سكنية (Residential Land)
- 🏗️ أرض تجارية (Commercial Land)
- 🌾 أرض زراعية (Agricultural Land)
- 🏪 محل تجاري (Shop)
- 🏢 مكتب (Office)
- 📦 مخزن (Warehouse)
- 🏛️ عمارة (Building)
- 🏡 بيت ريفي (Rural House)
- 🏖️ شاليه (Chalet)

#### Offer Type
Select from 4 types:
- للبيع (For Sale)
- للإيجار (For Rent)
- للبيع أو الإيجار (For Sale or Rent)
- للاستثمار (For Investment)

#### Location (3-Level Cascading)
1. Select Governorate (محافظة)
2. Select District (مديرية) - loads automatically
3. Select Neighborhood (حي) - loads automatically

#### Price Range
- Minimum Price (من)
- Maximum Price (إلى)

### Step 4: Apply Filters
Tap the "تطبيق" (Apply) button.

### Step 5: View Results
Properties list updates with filtered results.

### Step 6: Clear Filters (Optional)
Tap "مسح الكل" (Clear All) to reset.

---

## 🎯 Common Search Scenarios

### Scenario 1: Find Villas for Sale
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  propertyTypeId: 3, // Villa
  offerTypeId: 1,    // For Sale
);
```

### Scenario 2: Find Apartments in Sanaa
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  propertyTypeId: 1, // Apartment
  governorateId: 2,  // Sanaa
);
```

### Scenario 3: Find Properties Under 100,000
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  maxPrice: 100000,
);
```

### Scenario 4: Find Properties in Price Range
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  minPrice: 100000,
  maxPrice: 500000,
);
```

### Scenario 5: Combined Search
```dart
context.read<PropertiesCubit>().getProperties(
  refresh: true,
  search: 'فيلا',
  propertyTypeId: 3,
  offerTypeId: 1,
  governorateId: 2,
  districtId: 5,
  minPrice: 100000,
  maxPrice: 500000,
);
```

---

## 📊 API Endpoints

### Property & Offer Types
```
GET /public/data/property-types
GET /public/data/offer-types
```

### Location Hierarchy
```
GET /public/data/governorates
GET /public/data/governorates/{id}/districts
GET /public/data/districts/{id}/neighborhoods
```

### Properties with Search
```
GET /public/properties?page=1&per_page=20&search=...&property_type_id=...
```

**Supported Parameters:**
- `page` - Page number
- `per_page` - Items per page
- `search` - Text search
- `property_type_id` - Property type filter
- `offer_type_id` - Offer type filter
- `governorate_id` - Governorate filter
- `district_id` - District filter
- `neighborhood_id` - Neighborhood filter
- `min_price` - Minimum price
- `max_price` - Maximum price

---

## 🎨 UI Components

### Filter Chips
1. **PropertyTypeFilterChip** - With emoji icons
2. **OfferTypeFilterChip** - With Material icons
3. **GovernorateFilterChip** - With districts count
4. **DistrictFilterChip** - Smaller size
5. **NeighborhoodFilterChip** - Smallest size

### Screens
1. **PropertiesScreen** - Main properties list with search
2. **AdvancedSearchScreen** - Complete search UI
3. **PropertyTypesExampleScreen** - Property types demo
4. **OfferTypesExampleScreen** - Offer types demo
5. **GovernoratesExampleScreen** - Governorates demo
6. **CascadingLocationSelectorScreen** - 2-level cascading demo
7. **CompleteLocationSelectorScreen** - 3-level cascading demo

---

## 🔧 State Management

### PropertiesCubit Methods

#### Get Properties
```dart
cubit.getProperties(
  refresh: true,
  search: 'keyword',
  propertyTypeId: 1,
  offerTypeId: 1,
  governorateId: 1,
  districtId: 1,
  neighborhoodId: 1,
  minPrice: 100000,
  maxPrice: 500000,
);
```

#### Load More (Pagination)
```dart
cubit.loadMore();
```

#### Clear Filters
```dart
cubit.clearFilters();
```

#### Check Active Filters
```dart
if (cubit.hasActiveFilters) {
  // Show indicator
}
```

#### Check Has More
```dart
if (cubit.hasMore) {
  // Show load more button
}
```

---

## 📁 File Locations

### Properties Feature
```
lib/features/properties/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── presentation/
│   ├── cubit/
│   │   ├── properties_cubit.dart
│   │   └── properties_state.dart
│   └── screens/
│       ├── properties_screen.dart
│       └── advanced_search_screen.dart
└── ADVANCED_SEARCH_GUIDE.md
```

### Filter Features
```
lib/features/
├── property_types/
├── offer_types/
├── governorates/
├── districts/
└── neighborhoods/
```

---

## 🎯 Key Features

### ✅ Implemented
- [x] 8 search parameters
- [x] Beautiful UI
- [x] Cascading location selection
- [x] Active filters indicator
- [x] Clear filters button
- [x] Filter counter
- [x] Price range inputs
- [x] Text search
- [x] Pagination with filters
- [x] RTL support
- [x] Bilingual support
- [x] Error handling
- [x] Loading states

---

## 📚 Documentation

### Main Documentation
1. **FINAL_IMPLEMENTATION_STATUS.md** - Complete status
2. **COMPLETE_PROJECT_SUMMARY.md** - Project overview
3. **ADVANCED_SEARCH_GUIDE.md** - Search guide
4. **COMPLETE_LOCATION_SYSTEM.md** - Location system
5. **QUICK_REFERENCE.md** - This file

### Feature Documentation
- Each feature has its own README.md
- Most have QUICK_START.md
- Some have INTEGRATION_GUIDE.md
- Some have ARCHITECTURE.md

---

## 🐛 Troubleshooting

### Issue: Filters not applying
**Solution:** Ensure `refresh: true` is passed to `getProperties()`

### Issue: Districts not loading
**Solution:** Select a governorate first

### Issue: Neighborhoods not loading
**Solution:** Select a district first

### Issue: Active filters indicator not showing
**Solution:** Check `hasActiveFilters` getter in cubit

### Issue: Pagination not working
**Solution:** Filters are automatically maintained in cubit state

---

## ✨ Tips & Best Practices

1. **Load filter data early** - Load property types, offer types, and governorates when app starts
2. **Cache filter data** - These rarely change, cache them locally
3. **Validate price range** - Ensure min < max
4. **Clear child selections** - Clear districts when governorate changes
5. **Show loading states** - Always show loading indicators
6. **Handle empty results** - Show helpful message when no properties match
7. **Preserve filters** - Maintain filters during pagination
8. **Provide clear action** - Easy way to reset all filters

---

## 🎉 Summary

**You have a complete, production-ready advanced search system!**

- ✅ 8 search parameters
- ✅ Beautiful UI
- ✅ Cascading filters
- ✅ Active filters management
- ✅ Full documentation
- ✅ No errors
- ✅ Ready to use

**Happy coding!** 🚀
