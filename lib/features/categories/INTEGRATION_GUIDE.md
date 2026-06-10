# Categories Feature - Integration Guide

## ✅ What's Been Implemented

The complete categories feature has been implemented with:

1. **Data Layer**
   - Remote data source for API calls
   - Categories model with proper JSON serialization
   - Repository implementation with error handling

2. **Domain Layer**
   - Category entities (CategoriesEntity, CategoryEntity, CategoryChildEntity)
   - Repository interface
   - GetCategories use case

3. **Presentation Layer**
   - CategoriesCubit for state management
   - CategoriesScreen with loading/error/success states
   - CategoryCard widget with expandable children
   - RTL support for Arabic/English

4. **Dependency Injection**
   - CategoriesInjection class for easy setup

## 🚀 Quick Start

### Step 1: Add to Your Navigation

In your home screen or any screen where you want to show categories:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/features/categories/di/categories_injection.dart';
import 'package:food_delivery/features/categories/presentation/screens/categories_screen.dart';

// Add a button or menu item
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

### Step 2: Test the Feature

1. Run your app: `flutter run`
2. Navigate to the categories screen
3. You should see:
   - Loading indicator while fetching
   - List of categories when loaded
   - Error message with retry button if failed

## 📱 UI Features

The categories screen includes:

- **Loading State**: Shows a circular progress indicator
- **Error State**: Displays error message with retry button
- **Success State**: Shows expandable category cards
- **Expandable Cards**: Categories with children can be expanded
- **Subcategories**: Displayed as chips inside expanded cards
- **RTL Support**: Automatically shows Arabic or English based on locale

## 🔧 Customization

### Change the UI

Edit `lib/features/categories/presentation/widgets/category_card.dart` to customize the card appearance.

### Add Category Selection

Modify `CategoryCard` to add an `onTap` callback:

```dart
class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final Function(CategoryEntity)? onTap;

  const CategoryCard({
    super.key, 
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(category),
      child: Card(
        // ... rest of the code
      ),
    );
  }
}
```

### Add to Bottom Navigation

If you want categories as a main tab:

```dart
// In your main_page.dart or similar
final screens = [
  const HomeScreen(),
  BlocProvider(
    create: (_) => CategoriesInjection.provideCategoriesCubit()
      ..fetchCategories(),
    child: const CategoriesScreen(),
  ),
  const CartScreen(),
  const ProfileScreen(),
];
```

## 🎨 Styling

The current design uses:
- Card-based layout
- Expandable tiles for categories with children
- Chip widgets for subcategories
- Material Design principles

To match your app's theme, modify the colors and styles in:
- `categories_screen.dart` - AppBar and overall layout
- `category_card.dart` - Card styling and colors

## 🔌 API Configuration

The endpoint is configured in `lib/core/database/api/end_points.dart`:

```dart
static const String categories = "menu/categories";
```

Make sure your base URL is correct:

```dart
static const String baseUrl = "https://vwline.com/api/v1/";
```

## 📊 Data Structure

The API response should match this structure:

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

## 🐛 Troubleshooting

### Categories not loading?

1. Check network connection
2. Verify the API endpoint is correct
3. Check the API response format matches the model
4. Look at console logs for error messages

### UI not showing?

1. Make sure you're wrapping with BlocProvider
2. Call `fetchCategories()` after creating the cubit
3. Check that the screen is properly navigated to

### Arabic text not showing?

1. Verify fonts are loaded in `pubspec.yaml`
2. Check that `Directionality` is set correctly
3. Ensure locale is properly configured in MaterialApp

## 📝 Next Steps

Consider adding:

1. **Category Images**: Add image URLs to the API and display them
2. **Category Filtering**: Filter products by selected category
3. **Search**: Add search functionality for categories
4. **Caching**: Cache categories locally for offline access
5. **Pull to Refresh**: Add swipe-to-refresh functionality
6. **Category Icons**: Add icons for each category type

## 💡 Tips

- The feature is fully independent and follows clean architecture
- You can easily modify any layer without affecting others
- State management is handled by Cubit (simpler than Bloc)
- All network errors are properly handled
- The UI is responsive and works on all screen sizes

## 📞 Support

If you encounter issues:

1. Check the README.md for detailed documentation
2. Review the example_usage.dart for usage examples
3. Verify all dependencies are installed
4. Check that the API is accessible and returning correct data
