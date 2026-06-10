# Category Products Feature

## Overview
Complete implementation of the category products feature that displays all products for a specific category. When users click on a category (from home screen or categories list), they navigate to a dedicated screen showing all products in that category.

## API Endpoint
```
GET menu/categories/{id}
```

### Response Structure
```json
{
  "success": true,
  "data": {
    "category": {
      "id": 2,
      "name": "Appetizers",
      "name_ar": "المقبلات",
      "image_url": null
    },
    "products": [
      {
        "id": 6,
        "name": "Falafel",
        "name_ar": "فلافل",
        "description": "Crispy fried chickpea balls",
        "description_ar": "كرات الحمص المقلية المقرمشة",
        "price": 12,
        "image_url": null,
        "has_variants": false,
        "has_modifiers": false,
        "is_bundle": false,
        "calories": "220.00",
        "preparation_time": 10
      }
    ],
    "pagination": {
      "current_page": 1,
      "last_page": 1,
      "per_page": 20,
      "total": 4
    }
  }
}
```

## Architecture

### Domain Layer
**Entities:**
- `CategoryProductsEntity`: Main entity containing category, products, and pagination
- `CategoryDetailEntity`: Category information
- `CategoryProductEntity`: Product information
- `PaginationEntity`: Pagination details

**Repository Interface:**
- `CategoryProductsRepository`: Abstract repository

**Use Cases:**
- `GetCategoryProducts`: Fetches products for a specific category

### Data Layer
**Models:**
- `CategoryProductsModel`: Extends CategoryProductsEntity
- `CategoryDetailModel`: Extends CategoryDetailEntity
- `CategoryProductModel`: Extends CategoryProductEntity
- `PaginationModel`: Extends PaginationEntity

**Data Sources:**
- `CategoryProductsRemoteDataSource`: Handles API calls

**Repository Implementation:**
- `CategoryProductsRepositoryImpl`: Implements CategoryProductsRepository

### Presentation Layer
**Cubit:**
- `CategoryProductsCubit`: Manages category products state
- `CategoryProductsState`: States (Initial, Loading, Loaded, Error)

**Screens:**
- `CategoryProductsScreen`: Main screen displaying products

**Dependency Injection:**
- `CategoryProductsInjection`: Provides all dependencies

## Features

### 1. Category Products Screen
- **App Bar**: Shows category name in Arabic
- **Search Bar**: Search functionality (ready for implementation)
- **Products Count**: Shows total number of products
- **Products Grid**: 2-column grid layout
- **Product Cards**: Image, name, price, preparation time
- **States**: Loading, error, empty, and loaded

### 2. Navigation
- **From Home Screen**: Click on category card → Navigate to products
- **From Categories Screen**: Click on category card → Navigate to products
- **BlocProvider**: Each navigation creates a new cubit instance

### 3. UI Components
- **Product Card**:
  - Product image (with fallback icon)
  - Product name in Arabic
  - Price in YER
  - Preparation time with clock icon
  - Tap to view details (ready for implementation)

## User Flow

```
User clicks on category
    ↓
Navigate to CategoryProductsScreen
    ↓
Screen opens with loading indicator
    ↓
Fetch products from API
    ↓
Display products in grid
    ↓
User can tap product to view details
```

## Integration Points

### Home Screen
```dart
CategorySummaryCard(
  category: category,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              CategoryProductsInjection.provideCategoryProductsCubit(),
          child: CategoryProductsScreen(
            categoryId: category.id,
            categoryName: category.nameAr,
          ),
        ),
      ),
    );
  },
)
```

### Categories Screen
```dart
CategoryCard(
  category: category,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              CategoryProductsInjection.provideCategoryProductsCubit(),
          child: CategoryProductsScreen(
            categoryId: category.id,
            categoryName: category.nameAr,
          ),
        ),
      ),
    );
  },
)
```

## File Structure
```
lib/features/categories/
├── data/
│   ├── datasources/
│   │   └── category_products_remote_data_source.dart
│   ├── models/
│   │   └── category_products_model.dart
│   └── repositories/
│       └── category_products_repository_impl.dart
├── di/
│   └── category_products_injection.dart
├── domain/
│   ├── entities/
│   │   └── category_products_entity.dart
│   ├── repositories/
│   │   └── category_products_repository.dart
│   └── usecases/
│       └── get_category_products.dart
└── presentation/
    ├── cubit/
    │   ├── category_products_cubit.dart
    │   └── category_products_state.dart
    └── screens/
        └── category_products_screen.dart
```

## Key Features

1. **Clean Architecture**: Complete separation of concerns
2. **State Management**: BlocProvider with local cubit instance
3. **Error Handling**: Retry button on error
4. **Empty State**: Message when no products
5. **Loading State**: Circular progress indicator
6. **Network Images**: With fallback to placeholder icon
7. **RTL Support**: Full Arabic support
8. **Responsive Grid**: 2-column layout
9. **Search Ready**: Search bar ready for implementation
10. **Product Details Ready**: Tap handler ready for navigation

## Future Enhancements

### TODO: Product Details Navigation
```dart
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(
          productId: product.id,
        ),
      ),
    );
  },
  child: ProductCard(...),
)
```

### TODO: Search Functionality
```dart
TextField(
  onChanged: (value) {
    // Filter products by search query
    setState(() {
      filteredProducts = products
          .where((p) => p.nameAr.contains(value))
          .toList();
    });
  },
)
```

### TODO: Pagination
```dart
// Load more products when scrolling to bottom
if (pagination.currentPage < pagination.lastPage) {
  context.read<CategoryProductsCubit>()
      .loadMoreProducts(categoryId, page: pagination.currentPage + 1);
}
```

## Testing

### Test Scenarios

1. **Navigation from Home**
   - ✅ Click category on home screen
   - ✅ Navigate to products screen
   - ✅ Show correct category name in app bar

2. **Navigation from Categories**
   - ✅ Click category in categories list
   - ✅ Navigate to products screen
   - ✅ Show correct category name in app bar

3. **Products Display**
   - ✅ Show loading indicator while fetching
   - ✅ Display products in 2-column grid
   - ✅ Show product image or placeholder
   - ✅ Show product name, price, and prep time

4. **Error Handling**
   - ✅ Show error message on failure
   - ✅ Show retry button
   - ✅ Retry fetches data again

5. **Empty State**
   - ✅ Show message when no products
   - ✅ Show icon and text

## Benefits

1. **Better UX**: Dedicated screen for browsing category products
2. **Performance**: Only loads products for selected category
3. **Scalability**: Supports pagination for large categories
4. **Consistency**: Same UI pattern as AllFoodsScreen
5. **Maintainability**: Clean Architecture makes it easy to extend

## Summary

The Category Products feature has been successfully implemented with complete Clean Architecture. Users can now click on any category (from home screen or categories list) to view all products in that category. The screen includes search functionality (ready for implementation), error handling, empty states, and is fully integrated with the existing navigation flow.
