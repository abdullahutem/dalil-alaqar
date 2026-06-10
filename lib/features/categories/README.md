# Categories Feature

This feature implements a complete categories system following Clean Architecture principles.

## 📁 Structure

```
categories/
├── data/
│   ├── datasources/
│   │   └── categories_remote_data_source.dart
│   ├── models/
│   │   └── categories_model.dart
│   └── repositories/
│       └── categories_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── categories_entitiy.dart
│   ├── repositories/
│   │   └── categories_repository.dart
│   └── usecases/
│       └── get_categories.dart
├── presentation/
│   ├── cubit/
│   │   ├── categories_cubit.dart
│   │   └── categories_state.dart
│   ├── screens/
│   │   └── categories_screen.dart
│   └── widgets/
│       └── category_card.dart
├── di/
│   └── categories_injection.dart
└── example_usage.dart
```

## 🔌 API Endpoint

**Endpoint:** `menu/categories`

**Response Structure:**
```json
{
  "categories": [
    {
      "id": 1,
      "odoo_id": null,
      "name": "Main Dishes",
      "name_ar": "الأطباق الرئيسية",
      "parent_id": null,
      "complete_name": null,
      "children": [
        {
          "id": 7,
          "name": "Grilled",
          "name_ar": "مشويات"
        }
      ],
      "is_active": true
    }
  ]
}
```

## 🚀 Usage

### Option 1: Navigate to Categories Screen

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/features/categories/di/categories_injection.dart';
import 'package:food_delivery/features/categories/presentation/screens/categories_screen.dart';

// In your widget
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => BlocProvider(
      create: (_) => CategoriesInjection.provideCategoriesCubit()
        ..fetchCategories(),
      child: const CategoriesScreen(),
    ),
  ),
);
```

### Option 2: Add to Main App

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/features/categories/di/categories_injection.dart';

MultiBlocProvider(
  providers: [
    BlocProvider(
      create: (_) => CategoriesInjection.provideCategoriesCubit(),
    ),
    // Other providers...
  ],
  child: MyApp(),
)
```

### Option 3: Use in Home Screen

```dart
// Add a button in your home screen
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => CategoriesInjection.provideCategoriesCubit()
            ..fetchCategories(),
          child: const CategoriesScreen(),
        ),
      ),
    );
  },
  child: const Text('عرض الفئات'),
)
```

## 📦 Features

- ✅ Clean Architecture implementation
- ✅ Bloc/Cubit state management
- ✅ Network error handling
- ✅ Loading states
- ✅ Retry functionality
- ✅ RTL support (Arabic/English)
- ✅ Nested categories (parent-child relationship)
- ✅ Expandable category cards
- ✅ Modern UI design

## 🎨 UI Components

### CategoriesScreen
Main screen that displays all categories with loading, error, and success states.

### CategoryCard
Reusable widget that displays a category with:
- Category name (Arabic/English based on locale)
- Expandable children list
- Chip-style subcategories
- Clean card design

## 🔧 Dependencies

Make sure these are in your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  dartz: ^0.10.1
  internet_connection_checker: ^1.0.0+1
  dio: ^5.3.3
```

## 📝 Notes

- The endpoint is already added to `lib/core/database/api/end_points.dart`
- The params class is added to `lib/core/params/params.dart`
- All models handle null safety properly
- The feature supports both Arabic and English localization
- Categories with children are expandable
- Active/inactive categories are handled via `is_active` field

## 🐛 Troubleshooting

If you encounter issues:

1. Make sure the base URL is correct in `end_points.dart`
2. Check network connectivity
3. Verify the API response matches the expected structure
4. Check that all dependencies are installed
5. Run `flutter pub get` after adding dependencies

## 🔄 Future Enhancements

- [ ] Add category filtering
- [ ] Add search functionality
- [ ] Add category images
- [ ] Cache categories locally
- [ ] Add pull-to-refresh
- [ ] Add category selection callback
- [ ] Integrate with products/menu items
