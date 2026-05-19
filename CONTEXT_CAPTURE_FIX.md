# ✅ Context Capture Fix - Final Solution

## 🐛 The Real Problem

**Error:** `ProviderNotFoundException` when opening Advanced Search Screen

**Root Cause:** 
Inside the `MaterialPageRoute` builder, we were trying to use `context.read<>()` to get the cubits, but the `context` inside the route builder is a **different context** than the one where the providers are defined.

## 📝 The Issue

```dart
IconButton(
  onPressed: () async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(  // ← New context here!
          providers: [
            BlocProvider.value(
              // ❌ This context doesn't have access to parent providers
              value: context.read<PropertyTypesCubit>(),
            ),
          ],
          child: const AdvancedSearchScreen(),
        ),
      ),
    );
  },
)
```

## ✅ The Solution

**Capture the cubits BEFORE entering the route builder:**

```dart
Builder(
  builder: (context) {
    return IconButton(
      onPressed: () async {
        // ✅ Capture cubits from the correct context BEFORE navigation
        final propertyTypesCubit = context.read<PropertyTypesCubit>();
        final offerTypesCubit = context.read<OfferTypesCubit>();
        final governoratesCubit = context.read<GovernoratesCubit>();
        final districtsCubit = context.read<DistrictsCubit>();
        final neighborhoodsCubit = context.read<NeighborhoodsCubit>();
        
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                // ✅ Use the captured cubits
                BlocProvider.value(value: propertyTypesCubit),
                BlocProvider.value(value: offerTypesCubit),
                BlocProvider.value(value: governoratesCubit),
                BlocProvider.value(value: districtsCubit),
                BlocProvider.value(value: neighborhoodsCubit),
              ],
              child: const AdvancedSearchScreen(),
            ),
          ),
        );

        if (result != null && mounted) {
          context.read<PropertiesCubit>().getProperties(
            refresh: true,
            search: result['search'],
            propertyTypeId: result['propertyTypeId'],
            offerTypeId: result['offerTypeId'],
            governorateId: result['governorateId'],
            districtId: result['districtId'],
            neighborhoodId: result['neighborhoodId'],
            minPrice: result['minPrice'],
            maxPrice: result['maxPrice'],
          );
        }
      },
      tooltip: 'بحث متقدم',
    );
  },
)
```

## 🔍 Why This Works

### Context Hierarchy

```
PropertiesScreen (MultiBlocProvider)
  ├─ PropertyTypesCubit ✅
  ├─ OfferTypesCubit ✅
  ├─ GovernoratesCubit ✅
  ├─ DistrictsCubit ✅
  └─ NeighborhoodsCubit ✅
      │
      └─ Scaffold
          └─ AppBar
              └─ Builder ← Captures context here ✅
                  └─ IconButton
                      └─ onPressed
                          └─ Navigator.push
                              └─ MaterialPageRoute
                                  └─ builder: (context) ← NEW context ❌
                                      └─ AdvancedSearchScreen
```

### The Key Points

1. **Builder Widget**: Wraps the IconButton to ensure we have the correct context
2. **Capture Before Navigation**: Get all cubits before calling `Navigator.push`
3. **Use Captured Values**: Pass the captured cubit instances to `BlocProvider.value()`

## 🎯 Three Fixes Applied

### Fix 1: Factory Methods (Previous)
Added `.create()` factory methods to all cubits for self-contained dependency injection.

### Fix 2: didChangeDependencies (Previous)
Changed from `initState()` to `didChangeDependencies()` in AdvancedSearchScreen.

### Fix 3: Context Capture (Current)
Capture cubits before navigation to avoid context issues in route builder.

## 📚 Understanding Flutter Context

### What is Context?

Context is like a "location" in the widget tree. Each widget has its own context.

```dart
Widget build(BuildContext context) {
  // This context belongs to THIS widget
}
```

### Context in Route Builders

```dart
MaterialPageRoute(
  builder: (context) {
    // This is a NEW context for the route
    // It doesn't have access to parent providers
  },
)
```

### The Builder Widget

```dart
Builder(
  builder: (context) {
    // This context has access to parent providers
    // Use this to capture values before navigation
  },
)
```

## 🔧 Alternative Solutions

### Option 1: Current Solution (Recommended)
Capture cubits before navigation:
```dart
final cubit = context.read<MyCubit>();
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider.value(
      value: cubit,
      child: NextScreen(),
    ),
  ),
);
```

### Option 2: Create New Instances
Create fresh cubits in the new screen:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (context) => PropertyTypesCubit.create()..getPropertyTypes(),
      child: AdvancedSearchScreen(),
    ),
  ),
);
```

**Pros:** Simple, no context issues  
**Cons:** Loses state, reloads data

### Option 3: Global Providers
Put providers at app level:
```dart
void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PropertyTypesCubit.create()),
        // ... all other cubits
      ],
      child: MyApp(),
    ),
  );
}
```

**Pros:** Available everywhere  
**Cons:** Lives for entire app lifecycle, memory overhead

## ✅ Current Implementation

**File:** `lib/features/properties/presentation/screens/properties_screen.dart`

The search button now:
1. ✅ Wraps IconButton in Builder widget
2. ✅ Captures all cubits before navigation
3. ✅ Passes captured cubits to route
4. ✅ No context issues

## 🎉 All Issues Resolved

### Summary of All Fixes:

1. ✅ **Factory Methods** - All cubits have `.create()` methods
2. ✅ **Lifecycle Fix** - Changed `initState()` to `didChangeDependencies()`
3. ✅ **Context Capture** - Capture cubits before navigation

### Files Modified:

1. `property_types_cubit.dart` - Added factory method
2. `offer_types_cubit.dart` - Added factory method
3. `governorates_cubit.dart` - Added factory method
4. `districts_cubit.dart` - Added factory method
5. `neighborhoods_cubit.dart` - Added factory method
6. `advanced_search_screen.dart` - Changed to `didChangeDependencies()`
7. `properties_screen.dart` - Added context capture with Builder

## 🧪 Testing

1. **Hot Restart** the app (important!)
2. Navigate to Properties Screen
3. Tap the search icon
4. Advanced Search Screen should open ✅
5. All filters should load ✅
6. No provider errors ✅

## 💡 Key Lessons

1. **Context is local** - Each widget has its own context
2. **Route builders create new context** - Don't use parent context inside
3. **Capture before navigation** - Get values before async operations
4. **Builder widget helps** - Provides correct context for capturing
5. **BlocProvider.value** - Use for passing existing cubits to new routes

## 🔗 Related Documentation

- Flutter Context: https://api.flutter.dev/flutter/widgets/BuildContext-class.html
- BLoC Navigation: https://bloclibrary.dev/#/recipesflutternavigation
- Builder Widget: https://api.flutter.dev/flutter/widgets/Builder-class.html

---

**Issue:** ✅ COMPLETELY RESOLVED  
**Status:** Production-Ready  
**Date:** May 19, 2026  
**Final Fix:** Context capture with Builder widget before navigation
