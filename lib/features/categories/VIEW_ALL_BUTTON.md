# Categories "View All" Button Implementation

## Overview
Added a "عرض الكل" (View All) button to the categories section on the home screen that navigates to a dedicated screen showing all categories using the categories API.

## Implementation

### 1. Updated Categories Screen
**File**: `lib/features/categories/presentation/screens/categories_screen.dart`

**Changes:**
- Converted from `StatelessWidget` to `StatefulWidget`
- Added `initState()` to fetch all categories when screen opens
- Added RTL support with `Directionality`
- Improved UI with better styling and error handling
- Added empty state when no categories exist
- Added `onTap` callback to category cards for future navigation to products

**Features:**
```dart
@override
void initState() {
  super.initState();
  // Fetch all categories when screen opens
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<CategoriesCubit>().fetchCategories();
  });
}
```

**UI Improvements:**
- Orange app bar matching app theme
- RTL text direction
- Error state with icon and retry button
- Empty state with icon and message
- Loading indicator
- Category cards with products count and images

### 2. Updated Home Screen Categories Section
**File**: `lib/features/home/presentation/screens/home_screen.dart`

**Changes:**
- Added "عرض الكل" button to categories section header
- Button navigates to `CategoriesScreen`
- Added import for `CategoriesScreen`

**Code:**
```dart
Widget _buildHomeCategoriesSection(HomeLoaded state) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text('التصنيفات', ...),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesScreen(),
                  ),
                );
              },
              child: const Text("عرض الكل", ...),
            ),
          ],
        ),
      ),
      // Categories horizontal list...
    ],
  );
}
```

## Data Flow

### Home Screen Categories (Limited)
```
Home Screen
    ↓
HomeCubit.fetchHome(limit: 10)
    ↓
GET menu/home?limit=10
    ↓
Returns first 10 categories
    ↓
Display in horizontal list
```

### All Categories Screen (Complete)
```
User taps "عرض الكل"
    ↓
Navigate to CategoriesScreen
    ↓
CategoriesCubit.fetchCategories()
    ↓
GET menu/categories
    ↓
Returns ALL categories
    ↓
Display in vertical list
```

## API Endpoints Used

### Home Screen
- **Endpoint**: `menu/home?limit=10`
- **Purpose**: Get limited categories for home screen preview
- **Returns**: First 10 categories with products_count

### Categories Screen
- **Endpoint**: `menu/categories`
- **Purpose**: Get all categories for dedicated screen
- **Returns**: All categories with products_count and image_url

## User Flow

1. **User opens app** → Home screen shows first 10 categories
2. **User taps "عرض الكل"** → Navigates to Categories Screen
3. **Categories Screen opens** → Automatically fetches all categories
4. **User sees all categories** → Can tap on any category to view products (TODO)

## UI Components

### Home Screen Categories Section
- **Header**: "التصنيفات" with category icon
- **Button**: "عرض الكل" in orange color
- **List**: Horizontal scrolling with 10 categories
- **Cards**: Category image, name, and products count badge

### Categories Screen
- **App Bar**: "جميع التصنيفات" with orange background
- **List**: Vertical scrolling with all categories
- **Cards**: Category image (60x60), name, products count, and arrow icon
- **States**: Loading, error, empty, and loaded

## Future Enhancements

### TODO: Navigate to Products by Category
When user taps on a category card, navigate to a products screen filtered by that category:

```dart
CategoryCard(
  category: category,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsByCategoryScreen(
          categoryId: category.id,
          categoryName: category.nameAr,
        ),
      ),
    );
  },
)
```

## Testing

### Test Scenarios

1. **Home Screen Categories**
   - ✅ Shows first 10 categories from home endpoint
   - ✅ Displays products count badge
   - ✅ Shows "عرض الكل" button

2. **View All Button**
   - ✅ Button is visible and clickable
   - ✅ Navigates to Categories Screen
   - ✅ Orange color matches theme

3. **Categories Screen**
   - ✅ Fetches all categories on open
   - ✅ Shows loading indicator while fetching
   - ✅ Displays all categories in vertical list
   - ✅ Shows error state with retry button
   - ✅ Shows empty state when no categories
   - ✅ Category cards are tappable

4. **Navigation**
   - ✅ Can navigate from home to categories screen
   - ✅ Can navigate back to home screen
   - ✅ State persists (uses global CategoriesCubit)

## Benefits

1. **Better UX**: Users can see all categories without scrolling horizontally
2. **Performance**: Home screen only loads 10 categories for faster initial load
3. **Scalability**: Can handle any number of categories in dedicated screen
4. **Consistency**: Uses same category card design in both screens
5. **State Management**: Global CategoriesCubit ensures data consistency

## Summary

The "عرض الكل" button has been successfully added to the home screen categories section. When clicked, it navigates to a dedicated Categories Screen that fetches and displays all categories using the `menu/categories` API endpoint. The home screen continues to show only the first 10 categories from the `menu/home` endpoint for optimal performance.
