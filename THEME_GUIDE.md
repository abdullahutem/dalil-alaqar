# Theme Guide - Dark & Light Mode

## Overview
The dalil_alaqar app supports both light and dark themes with seamless switching. This guide explains how to implement theme-aware UI components.

## Theme System Architecture

### Theme Management
```dart
// Theme Cubit (State Management)
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: false));
  
  void toggleTheme() {
    emit(ThemeState(isDarkMode: !state.isDarkMode));
  }
  
  void setDarkMode(bool isDark) {
    emit(ThemeState(isDarkMode: isDark));
  }
}

// Theme State
class ThemeState extends Equatable {
  final bool isDarkMode;
  
  const ThemeState({required this.isDarkMode});
  
  @override
  List<Object?> get props => [isDarkMode];
}
```

### App Configuration
```dart
// In main.dart
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: themeState.isDarkMode 
      ? ThemeMode.dark 
      : ThemeMode.light,
)
```

## Color System

### AppColors Class
Located in `lib/core/theme/app_colors.dart`

```dart
class AppColors {
  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF242424);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  
  // Common Colors (work in both themes)
  static const Color primary = Color(0xFF038086);
  static const Color error = Color(0xFFCF6679);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF000000);
}
```

## Theme Usage Patterns

### 1. Backgrounds

```dart
// ✅ Scaffold Background
Scaffold(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
)

// ✅ Container Background
Container(
  color: Theme.of(context).scaffoldBackgroundColor,
)

// ✅ Card Background
Card(
  color: Theme.of(context).cardColor,
)
```

### 2. Text Styles

```dart
// ✅ Title Text
Text(
  'Title',
  style: Theme.of(context).textTheme.titleLarge,
)

// ✅ Body Text
Text(
  'Body',
  style: Theme.of(context).textTheme.bodyLarge,
)

// ✅ Secondary Text
Text(
  'Secondary',
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
  ),
)

// ✅ Custom Text with Theme Color
Text(
  'Custom',
  style: TextStyle(
    color: Theme.of(context).textTheme.bodyLarge?.color,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
)
```

### 3. Icons

```dart
// ✅ Icon with Theme Color
Icon(
  Icons.home_outlined,
  color: Theme.of(context).iconTheme.color,
)

// ✅ Icon with Custom Color (theme-aware)
Icon(
  Icons.star,
  color: AppColors.primary,  // Works in both themes
)

// ✅ Icon with Grey
Icon(
  Icons.info_outline,
  color: Colors.grey[600],  // Adapts to both themes
)
```

### 4. Buttons

```dart
// ✅ Elevated Button
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
  child: Text('Button'),
)

// ✅ Text Button
TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    foregroundColor: AppColors.primary,
  ),
  child: Text('Button'),
)

// ✅ Outlined Button
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: AppColors.primary,
    side: BorderSide(color: AppColors.primary),
  ),
  child: Text('Button'),
)
```

### 5. Cards

```dart
// ✅ Basic Card
Card(
  color: Theme.of(context).cardColor,
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(
          'Title',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    ),
  ),
)

// ✅ Card with Shadow
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(8),
    
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 8,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: // content
)
```

### 6. Dividers

```dart
// ✅ Horizontal Divider
Divider(
  color: Theme.of(context).dividerColor,
)

// ✅ Vertical Divider
VerticalDivider(
  color: Theme.of(context).dividerColor,
)

// ✅ Custom Divider
Container(
  height: 1,
  color: Theme.of(context).dividerColor,
)
```

### 7. Containers with Backgrounds

```dart
// ✅ Info Container
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.grey[100],  // Light mode
    // In dark mode, this becomes grey[800] automatically
    borderRadius: BorderRadius.circular(8),
  ),
)

// ✅ Better - Use Theme
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(8),
  ),
)
```

### 8. Overlays and Gradients

```dart
// ✅ Image Overlay (works in both themes)
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withOpacity(0.3),
        Colors.black.withOpacity(0.6),
      ],
    ),
  ),
)

// ✅ Modal Barrier
Container(
  color: Colors.black.withOpacity(0.5),
)
```

## Common Mistakes to Avoid

### ❌ Don't Do This

```dart
// ❌ Hardcoded white background
Container(color: Colors.white)

// ❌ Hardcoded black text
Text('Hello', style: TextStyle(color: Colors.black))

// ❌ Hardcoded grey
Container(color: Colors.grey[300])

// ❌ Assuming light background
Container(
  color: Colors.white,
  child: Text('Text', style: TextStyle(color: Colors.black)),
)

// ❌ Heavy shadows in dark mode
BoxShadow(
  color: Colors.black.withOpacity(0.5),
  blurRadius: 20,
)
```

### ✅ Do This Instead

```dart
// ✅ Theme-aware background
Container(color: Theme.of(context).cardColor)

// ✅ Theme-aware text
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)

// ✅ Theme-aware grey
Colors.grey[600]  // Adapts to theme

// ✅ Theme-aware container
Container(
  color: Theme.of(context).cardColor,
  child: Text('Text', style: Theme.of(context).textTheme.bodyLarge),
)

// ✅ Subtle shadows
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

## Complete Widget Examples

### Example 1: Property Card

```dart
class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(property.imageUrl),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  property.title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 8),
                
                // Location
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        property.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Price
                Text(
                  property.price,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Example 2: Section Header

```dart
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onSeeAll;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: Text('عرض الكل'),
            ),
        ],
      ),
    );
  }
}
```

### Example 3: Info Container

```dart
class InfoContainer extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

## Testing Themes

### Toggle Theme
```dart
// In any widget with context
IconButton(
  icon: Icon(
    context.watch<ThemeCubit>().state.isDarkMode
        ? Icons.light_mode_outlined
        : Icons.dark_mode_outlined,
  ),
  onPressed: () {
    context.read<ThemeCubit>().toggleTheme();
  },
)
```

### Check Current Theme
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;

if (isDark) {
  // Dark mode specific logic
} else {
  // Light mode specific logic
}
```

### Testing Checklist

#### Visual Testing
- [ ] All screens in light mode
- [ ] All screens in dark mode
- [ ] Text readability in both modes
- [ ] Card visibility in both modes
- [ ] Icon visibility in both modes
- [ ] Button colors in both modes
- [ ] Image overlays in both modes
- [ ] Shadows appropriate in both modes

#### Code Review
- [ ] No hardcoded Colors.white
- [ ] No hardcoded Colors.black
- [ ] No hardcoded Colors.grey[X] for backgrounds
- [ ] All text uses Theme.of(context).textTheme
- [ ] All containers use Theme.of(context) colors
- [ ] All cards use Theme.of(context).cardColor
- [ ] All icons use theme colors or AppColors
- [ ] Shadows use low opacity

## Quick Reference

### Most Common Theme Properties

```dart
// Backgrounds
Theme.of(context).scaffoldBackgroundColor
Theme.of(context).cardColor

// Text
Theme.of(context).textTheme.titleLarge
Theme.of(context).textTheme.titleMedium
Theme.of(context).textTheme.bodyLarge
Theme.of(context).textTheme.bodyMedium

// Colors
Theme.of(context).primaryColor
Theme.of(context).dividerColor
Theme.of(context).iconTheme.color

// Brightness
Theme.of(context).brightness  // Brightness.light or Brightness.dark
```

### AppColors Quick Reference

```dart
// Always use these (work in both themes)
AppColors.primary
AppColors.error
AppColors.success
AppColors.warning

// Use with Theme.of(context) for backgrounds
Theme.of(context).scaffoldBackgroundColor
Theme.of(context).cardColor

// Use for secondary text
Colors.grey[600]
```

## Summary

1. **Always use `Theme.of(context)`** for colors
2. **Never hardcode** Colors.white or Colors.black
3. **Use AppColors** for primary, error, success colors
4. **Test in both themes** before committing
5. **Use subtle shadows** (opacity 0.08)
6. **Follow the examples** in this guide

By following these guidelines, your UI will seamlessly support both light and dark modes! 🌓
