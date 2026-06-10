# Categories Feature - Quick Reference Card

## 🚀 Already Integrated!

The categories feature is **already working** in your home screen. Just run the app!

## 📍 Where to Find It

**File:** `lib/features/screens/home_screen.dart`  
**Method:** `_buildCategoriesSection()`  
**Location:** Between AdCarousel and Food Types sections

## 🎨 UI Style

- Horizontal scrolling list
- 80px width per category
- 40x40 icons/images
- Orange selection (#FFA726)
- Grey border for unselected
- Matches original design exactly

## 🔧 Quick Customization

### Change Selection Behavior

```dart
// In home_screen.dart, _buildCategoriesSection()
CategoriesHorizontalList(
  onCategorySelected: (category) {
    // Add your code here
    Navigator.push(...); // Navigate
    // OR
    setState(() { ... }); // Filter products
  },
)
```

### Use Icons Instead of Images

```dart
CategoriesHorizontalList(
  useImages: false, // Icons only
  onCategorySelected: (category) { ... },
)
```

### Map Custom Icons

```dart
// In category_icon_mapper.dart
static IconData getIconForCategory(String categoryName) {
  final iconMap = {
    'الأطباق الرئيسية': Icons.restaurant,
    'Your Category': Icons.your_icon,
  };
  return iconMap[categoryName] ?? Icons.restaurant_menu;
}
```

### Map Custom Images

```dart
// In category_icon_mapper.dart
static String? getImageForCategory(String categoryName) {
  final imageMap = {
    'الأطباق الرئيسية': 'assets/images/main.png',
    'Your Category': 'assets/images/your_image.png',
  };
  return imageMap[categoryName];
}
```

## 🔌 API Details

**Endpoint:** `menu/categories`  
**Base URL:** `https://vwline.com/api/v1/`  
**Full URL:** `https://vwline.com/api/v1/menu/categories`  
**Method:** GET

## 📊 States

| State | What Shows |
|-------|-----------|
| Loading | Circular progress indicator |
| Success | Horizontal categories list |
| Error | Error message + Retry button |
| Empty | Nothing (widget hidden) |

## 🎯 Common Tasks

### Remove Static Food Types

```dart
// In home_screen.dart, comment out:
// SliverToBoxAdapter(child: _buildFoodTypesSection()),
```

### Navigate on Selection

```dart
onCategorySelected: (category) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CategoryScreen(category: category),
    ),
  );
}
```

### Filter Products

```dart
onCategorySelected: (category) {
  setState(() {
    filteredProducts = products
        .where((p) => p.categoryId == category.id)
        .toList();
  });
}
```

### Show Category Name

```dart
onCategorySelected: (category) {
  print('Selected: ${category.nameAr}'); // Arabic
  print('Selected: ${category.name}');   // English
  print('ID: ${category.id}');
}
```

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| Categories not showing | Check API endpoint and network |
| Images not loading | Verify paths in category_icon_mapper.dart |
| Selection not working | Check onCategorySelected callback |
| Wrong language | Check Directionality in context |

## 📁 Key Files

| File | Purpose |
|------|---------|
| `home_screen.dart` | Integration point |
| `categories_horizontal_list.dart` | Main widget |
| `category_icon_mapper.dart` | Icons/images mapping |
| `categories_injection.dart` | Dependency injection |
| `categories_cubit.dart` | State management |

## ✅ Checklist

- [x] Feature implemented
- [x] Integrated in home screen
- [x] UI matches original design
- [x] No errors
- [x] Documentation complete
- [x] Ready to use

## 📚 Full Documentation

- `README.md` - Complete overview
- `INTEGRATION_GUIDE.md` - Integration steps
- `HOME_SCREEN_INTEGRATION.md` - Home screen specific
- `FINAL_SUMMARY.md` - Complete summary
- `ARCHITECTURE.md` - Architecture details

## 🎉 That's It!

Run your app and see the categories in action!

```bash
flutter run
```

---

**Need Help?** Check the full documentation files in the categories folder.
