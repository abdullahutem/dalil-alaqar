# Search Implementation - Category Products Screen

## Overview
Implemented real-time search functionality for filtering products within a category.

## Implementation Details

### 1. State Management
```dart
String searchQuery = '';
```
- Tracks the current search query
- Resets when switching categories

### 2. Search Handler
```dart
void _onSearchChanged(String query) {
  setState(() {
    searchQuery = query;
  });
}
```
- Updates search query on every keystroke
- Triggers UI rebuild to show filtered results

### 3. Filter Logic
```dart
List<CategoryProductEntity> _filterProducts(List<CategoryProductEntity> products) {
  if (searchQuery.isEmpty) {
    return products;
  }
  return products.where((product) {
    return product.nameAr.contains(searchQuery) ||
        product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        product.descriptionAr.contains(searchQuery) ||
        product.description.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
}
```
- Searches in both Arabic and English names
- Searches in both Arabic and English descriptions
- Case-insensitive for English text
- Returns all products if search is empty

### 4. UI Integration

#### Search Bar
```dart
TextField(
  onChanged: _onSearchChanged,
  // ...
)
```
- Connected to `_onSearchChanged` handler
- Updates search query in real-time

#### Products Count Display
```dart
Text(
  searchQuery.isEmpty
      ? '${allProducts.length} منتج'
      : '${filteredProducts.length} من ${allProducts.length} منتج',
)
```
- Shows total count when no search
- Shows "X من Y منتج" when searching (e.g., "4 من 10 منتج")

#### Empty Search Results
```dart
filteredProducts.isEmpty
    ? Center(
        child: Column(
          children: [
            Icon(Icons.search_off),
            Text('لا توجد نتائج للبحث'),
          ],
        ),
      )
    : _buildProductsGrid(filteredProducts)
```
- Shows friendly message when no results found
- Uses search_off icon for visual feedback

### 5. Category Switching Behavior
```dart
void _onCategorySelected(int categoryId, String categoryName) {
  setState(() {
    selectedCategoryId = categoryId;
    selectedCategoryName = categoryName;
    searchQuery = ''; // Clear search when switching categories
  });
  context.read<CategoryProductsCubit>().fetchCategoryProducts(categoryId);
}
```
- Automatically clears search when user switches categories
- Prevents confusion from stale search results

## Features
✅ Real-time search as user types
✅ Searches in Arabic and English
✅ Searches in both name and description
✅ Shows filtered count vs total count
✅ Empty state for no results
✅ Clears search when switching categories
✅ Case-insensitive English search
✅ No API calls - filters locally for instant results

## User Experience
1. User types in search bar
2. Products filter instantly (no delay)
3. Count updates to show "X من Y منتج"
4. If no results, shows friendly empty state
5. Switching categories clears search automatically
6. Works with both Arabic and English input
