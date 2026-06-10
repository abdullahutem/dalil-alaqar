# Categories Integration in Home Screen

## ✅ What Was Done

The categories feature has been successfully integrated into the home screen with the same UI style as the original `_buildFoodTypesSection`.

## 📁 Files Modified

1. **lib/features/screens/home_screen.dart**
   - Added imports for categories feature
   - Added `_buildCategoriesSection()` method
   - Integrated categories widget into the CustomScrollView
   - Kept original `_buildFoodTypesSection()` as fallback

## 📁 Files Created

1. **lib/features/categories/presentation/widgets/categories_horizontal_list.dart**
   - Horizontal scrolling categories list
   - Matches the original UI design
   - Supports both images and icons
   - Handles loading, error, and success states

2. **lib/features/categories/presentation/widgets/category_icon_mapper.dart**
   - Maps category names to icons
   - Maps category names to colors
   - Maps category names to asset images
   - Supports both English and Arabic names

## 🎨 UI Features

The categories widget has the same style as the original food types section:

- ✅ Horizontal scrolling list
- ✅ 80px width containers
- ✅ Rounded borders (25px radius)
- ✅ Orange selection color (#FFA726)
- ✅ Grey border for unselected items
- ✅ 40x40 icons/images
- ✅ Category name below icon
- ✅ Selection state management
- ✅ Tap to select functionality

## 🔄 How It Works

### 1. Categories Section (API Data)

```dart
Widget _buildCategoriesSection() {
  return BlocProvider(
    create: (_) => CategoriesInjection.provideCategoriesCubit()
      ..fetchCategories(),
    child: CategoriesHorizontalList(
      onCategorySelected: (category) {
        print('Selected category: ${category.nameAr}');
        // Handle category selection
      },
    ),
  );
}
```

### 2. Food Types Section (Static Data - Kept as Fallback)

The original `_buildFoodTypesSection()` is still there and working. It shows below the categories section.

## 📱 Current Layout

```
Home Screen
├── AppBar
├── SearchBar
├── AdCarousel
├── Categories Section (API) ← NEW
├── Food Types Section (Static) ← ORIGINAL (kept)
├── Offers Section
├── New Dishes Section
└── Most Popular Section
```

## 🎯 Category Selection

When a category is tapped:

1. The category is visually selected (orange border)
2. The `onCategorySelected` callback is triggered
3. You can handle the selection to:
   - Filter products
   - Navigate to category screen
   - Update other UI elements

### Example: Navigate on Selection

```dart
CategoriesHorizontalList(
  onCategorySelected: (category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(
          category: category,
        ),
      ),
    );
  },
)
```

### Example: Filter Products

```dart
CategoriesHorizontalList(
  onCategorySelected: (category) {
    setState(() {
      selectedCategoryId = category.id;
      // Filter your products list
      filteredProducts = products
          .where((p) => p.categoryId == category.id)
          .toList();
    });
  },
)
```

## 🖼️ Image Support

The widget tries to use images first, then falls back to icons:

1. **With Images** (default):
   ```dart
   CategoriesHorizontalList(useImages: true)
   ```

2. **With Icons Only**:
   ```dart
   CategoriesHorizontalList(useImages: false)
   ```

## 🎨 Customizing Icons/Images

Edit `category_icon_mapper.dart` to customize:

### Add New Category Mapping

```dart
static String? getImageForCategory(String categoryName) {
  final imageMap = {
    'الأطباق الرئيسية': 'assets/images/main_dishes.png',
    'المقبلات': 'assets/images/appetizers.png',
    // Add your mappings here
  };
  return imageMap[categoryName];
}
```

### Change Icons

```dart
static IconData getIconForCategory(String categoryName) {
  final iconMap = {
    'الأطباق الرئيسية': Icons.restaurant,
    'المقبلات': Icons.tapas,
    // Add your mappings here
  };
  return iconMap[categoryName] ?? Icons.restaurant_menu;
}
```

## 🔧 States Handled

### Loading State
Shows a circular progress indicator while fetching categories.

### Error State
Shows error message with retry button if API call fails.

### Success State
Shows the horizontal scrolling list of categories.

### Empty State
Hides the widget if no categories are returned.

## 🚀 Testing

1. **Run the app**: `flutter run`
2. **Navigate to home screen**
3. **You should see**:
   - Loading indicator briefly
   - Then categories list from API
   - Below that, the original static food types

## 🔄 Removing Static Food Types (Optional)

If you want to remove the static food types section after confirming categories work:

1. In `home_screen.dart`, find this line:
   ```dart
   SliverToBoxAdapter(child: _buildFoodTypesSection()),
   ```

2. Comment it out or remove it:
   ```dart
   // SliverToBoxAdapter(child: _buildFoodTypesSection()),
   ```

## 📝 Notes

- Both sections can coexist without conflicts
- The categories section uses API data
- The food types section uses static data
- No existing functionality was broken
- All original methods are preserved
- The UI style matches perfectly

## 🐛 Troubleshooting

### Categories not showing?

1. Check API endpoint is correct
2. Verify network connection
3. Check console for errors
4. Ensure base URL is correct in `end_points.dart`

### Images not showing?

1. Verify image paths in `category_icon_mapper.dart`
2. Check that images exist in `assets/images/`
3. Ensure images are declared in `pubspec.yaml`
4. Icons will show as fallback if images fail

### Selection not working?

1. Check that `onCategorySelected` callback is provided
2. Verify state is updating correctly
3. Check console for print statements

## ✨ Next Steps

1. **Remove static section** (optional) once categories are confirmed working
2. **Add category filtering** to filter products by selected category
3. **Add navigation** to category-specific screens
4. **Customize icons/images** to match your categories
5. **Add analytics** to track category selections

---

The integration is complete and ready to use! The categories now load from the API and display in the same style as your original food types section.
