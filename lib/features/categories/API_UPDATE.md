# Categories API Update

## Changes Made

### API Response Structure Changed
The categories API response structure has been updated:

**Old Structure:**
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
      "children": [...],
      "is_active": true
    }
  ]
}
```

**New Structure:**
```json
{
  "success": true,
  "data": {
    "categories": [
      {
        "id": 2,
        "name": "Appetizers",
        "name_ar": "المقبلات",
        "image_url": null,
        "products_count": 4
      }
    ]
  }
}
```

### Key Changes

1. **Response Wrapper**: Added `success` and `data` wrapper
2. **Removed Fields**:
   - `odoo_id`
   - `parent_id`
   - `complete_name`
   - `children` array
   - `is_active`

3. **Added Fields**:
   - `image_url`: URL for category image (nullable)
   - `products_count`: Number of products in the category

### Usage Change

**IMPORTANT**: The categories API (`menu/categories`) is **NO LONGER USED** on the home screen.

- **Home Screen**: Uses categories from the `menu/home` endpoint
- **Categories API**: Only used when showing all categories in a dedicated screen

## Updated Files

### 1. Domain Layer
**File**: `lib/features/categories/domain/entities/categories_entitiy.dart`

```dart
class CategoryEntity {
  final int id;
  final String name;
  final String nameAr;
  final String? imageUrl;        // NEW
  final int productsCount;       // NEW
}
```

### 2. Data Layer
**File**: `lib/features/categories/data/models/categories_model.dart`

- Updated `fromJson` to handle new response structure with `success` and `data` wrapper
- Removed parsing for old fields (odoo_id, parent_id, children, etc.)
- Added parsing for new fields (image_url, products_count)

### 3. Presentation Layer

**File**: `lib/features/categories/presentation/widgets/category_card.dart`
- Updated to show category image (with fallback to chicken.png)
- Shows products count instead of children count
- Added onTap callback for navigation

**File**: `lib/features/categories/presentation/widgets/categories_horizontal_list.dart`
- Updated to display category images
- Shows products count badge
- Improved styling with selection state

### 4. Home Screen
**File**: `lib/features/home/presentation/screens/home_screen.dart`

- **Removed**: Categories API call from `initState()`
- **Removed**: `_buildCategoriesSection()` method (fallback to categories API)
- **Uses**: Only `_buildHomeCategoriesSection()` which gets data from home endpoint
- Categories on home screen now come exclusively from `menu/home` endpoint

## Migration Guide

### For Home Screen
No action needed - categories automatically come from home endpoint.

### For Categories Screen (All Categories)
Use the categories API when you need to show all categories:

```dart
// Fetch all categories
context.read<CategoriesCubit>().fetchCategories();

// Display categories
BlocBuilder<CategoriesCubit, CategoriesState>(
  builder: (context, state) {
    if (state is CategoriesLoaded) {
      return ListView.builder(
        itemCount: state.categories.length,
        itemBuilder: (context, index) {
          final category = state.categories[index];
          return CategoryCard(
            category: category,
            onTap: () {
              // Navigate to category products
            },
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

## Benefits

1. **Simplified Structure**: Removed unnecessary nested fields
2. **Better Performance**: Home screen makes one API call instead of two
3. **Products Count**: Categories now show how many products they contain
4. **Image Support**: Categories can have custom images
5. **Cleaner Code**: Removed unused fields and complexity

## Backward Compatibility

⚠️ **Breaking Changes**: This update is NOT backward compatible with the old API structure.

If you need to support both old and new structures, you can update the model's `fromJson` to handle both:

```dart
factory CategoriesModel.fromJson(Map<String, dynamic> json) {
  // Try new structure first
  if (json.containsKey('success') && json.containsKey('data')) {
    final data = json['data'];
    return CategoriesModel(
      categories: (data['categories'] as List)
          .map((category) => CategoryModel.fromJson(category))
          .toList(),
    );
  }
  
  // Fallback to old structure
  return CategoriesModel(
    categories: (json['categories'] as List)
        .map((category) => CategoryModel.fromJson(category))
        .toList(),
  );
}
```

## Testing

Test the following scenarios:

1. ✅ Home screen displays categories from home endpoint
2. ✅ Categories show products count badge
3. ✅ Category images display (or fallback to chicken.png)
4. ✅ Categories API works independently for all categories screen
5. ✅ Category selection works correctly
6. ✅ No errors when categories API is not called on home screen

## Summary

The categories feature has been updated to match the new API structure. The home screen now exclusively uses the home endpoint for categories, while the categories API is reserved for dedicated category browsing screens. This improves performance and simplifies the codebase.
