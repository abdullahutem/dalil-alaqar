# Feature Generation Prompt Template

Use this prompt template to generate new features following the project's architecture pattern.

---

## Prompt Template

```
I need you to create a new feature called "[FEATURE_NAME]" for a Flutter app following clean architecture.

### API Endpoint Information
- **Endpoint**: [ENDPOINT_URL]
- **Method**: [GET/POST/PUT/DELETE]
- **Query Parameters** (if any): [LIST_PARAMETERS]
- **Response Structure**:
```json
[PASTE_API_RESPONSE_HERE]
```

### Feature Requirements

#### 1. Domain Layer
Create the following in `lib/features/[feature_name]/domain/`:
- **Entities**: Define entity classes based on the API response structure
- **Repository Interface**: Abstract repository with method signatures
- **Use Cases**: Business logic use cases (e.g., Get[FeatureName]UseCase)

#### 2. Data Layer
Create the following in `lib/features/[feature_name]/data/`:
- **Models**: Data models extending entities with `fromJson` and `toJson` methods
- **Remote Data Source**: API consumer implementation
- **Repository Implementation**: Concrete repository with error handling

**Important Notes:**
- Handle nullable fields appropriately (check API response for null values)
- Use proper error handling (ServerException, DioException)
- Include NetworkInfo check for internet connectivity with null coalescing: `if (!(await networkInfo.isConnected ?? false))`
- Follow the existing pattern from `lib/features/properties/` or `lib/features/advertisements/`

**Repository Implementation Pattern:**
```dart
@override
Future<Either<Failure, [Feature]ResponseEntity>> get[Feature]s({
  required int page,
  required int perPage,
}) async {
  // ✅ CORRECT - Handle nullable bool with ?? false
  if (!(await networkInfo.isConnected ?? false)) {
    return Left(Failure(errMessage: 'لا يوجد اتصال بالإنترنت'));
  }
  
  try {
    final result = await remoteDataSource.get[Feature]s(
      page: page,
      perPage: perPage,
    );
    return Right(result);
  } on ServerException catch (e) {
    return Left(ServerFailure(errMessage: e.errorModel.errorMessage));
  }
}
```

#### 3. Presentation Layer
Create the following in `lib/features/[feature_name]/presentation/`:

**Cubit (State Management):**
- States: Initial, Loading, Success, Error, LoadMoreError (if pagination needed)
- Cubit with factory method `[FeatureName]Cubit.create()` for dependency injection
- Implement pagination logic if needed (similar to PropertiesCubit)

**Screens:**
- `[feature_name]_screen.dart` - Main screen with LayoutBuilder
- `[feature_name]_mobile_layout.dart` - Mobile-specific layout (< 600px)
- `[feature_name]_tablet_layout.dart` - Tablet-specific layout (≥ 600px)

**Widgets:**
- `[feature_name]_card.dart` - Card widget for displaying individual items
- `[feature_name]_card_compact.dart` - Compact card for horizontal scrolling (if needed for home screen)
- `[feature_name]_section.dart` - Section widget for home screen integration (if needed)

#### 4. Home Screen Integration (Optional)
If this feature should appear on the home screen:
- Create a horizontal scrolling section
- Use compact cards (280px wide)
- Show first 10 items
- Add "Show All" button
- Update `home_mobile_layout.dart` and `home_tablet_layout.dart`

#### 5. Additional Requirements
- Add endpoint to `lib/core/databases/api/end_points.dart`
- Follow existing naming conventions
- Use proper Arabic text for UI
- Implement pull-to-refresh
- Add loading, error, and empty states
- Include proper image caching if images are involved
- Format numbers appropriately (prices, counts, etc.)
- Add proper navigation between screens
- **Support dark and light modes**:
  - Use `Theme.of(context)` for dynamic colors
  - Use `AppColors` constants (lightBackground, darkBackground, etc.)
  - Avoid hardcoded colors
  - Test in both themes
  - Ensure text is readable in both modes
  - Card backgrounds should adapt to theme

### Design Guidelines

**Mobile Layout:**
- Vertical scrolling list
- Full-width cards
- 16px padding
- Standard font sizes

**Tablet Layout:**
- 2-column grid layout
- Max width: 1200px
- 24px padding
- Slightly larger font sizes
- Centered content

**Card Design:**
- Rounded corners (12px)
- Shadow for depth
- Clean, minimal design
- Essential information only
- Proper image aspect ratios

**Dark/Light Mode Support:**
- Use `Theme.of(context)` for colors
- Use `AppColors` constants appropriately:
  - Light mode: `AppColors.lightBackground`, `AppColors.lightSurface`, `AppColors.lightText`
  - Dark mode: `AppColors.darkBackground`, `AppColors.darkSurface`, `AppColors.darkText`
- Avoid hardcoded colors (use theme colors)
- Test in both light and dark modes
- Use `Colors.grey[X]` with context awareness
- Card backgrounds should adapt to theme
- Text colors should adapt to theme
- Icons should use theme colors

### Code Quality Requirements
- ✅ No diagnostics errors
- ✅ Proper null safety
- ✅ Clean code structure
- ✅ Consistent naming
- ✅ Proper error handling
- ✅ Performance optimized
- ✅ Responsive design
- ✅ RTL support
- ✅ Dark/Light mode support
- ✅ Theme-aware colors
- ✅ Accessibility compliant
- ✅ Use modern Flutter APIs (no deprecated methods)

### Deliverables
1. Complete domain layer (entities, repository, use cases)
2. Complete data layer (models, data sources, repository implementation)
3. Complete presentation layer (cubit, states, screens, widgets)
4. Home screen integration (if applicable)
5. README.md documenting the feature
6. All files should pass diagnostics
7. **Theme support verified in both light and dark modes**

### Theme Support Guidelines

The app supports both light and dark modes. Follow these guidelines:

**1. Use Theme Colors:**
```dart
// ✅ Good - Uses theme
Container(
  color: Theme.of(context).cardColor,
  child: Text(
    'Hello',
    style: Theme.of(context).textTheme.bodyLarge,
  ),
)

// ❌ Bad - Hardcoded colors
Container(
  color: Colors.white,
  child: Text(
    'Hello',
    style: TextStyle(color: Colors.black),
  ),
)
```

**2. Use AppColors Constants:**
```dart
// For primary colors
color: AppColors.primary

// For backgrounds (theme-aware)
color: Theme.of(context).scaffoldBackgroundColor

// For cards
color: Theme.of(context).cardColor

// For text
color: Theme.of(context).textTheme.bodyLarge?.color
```

**3. Opacity - IMPORTANT: Use .withValues() NOT .withOpacity():**
```dart
// ✅ CORRECT - Use .withValues(alpha: ...)
Colors.black.withValues(alpha: 0.08)
theme.colorScheme.primary.withValues(alpha: 0.1)
Colors.grey.withValues(alpha: 0.3)
theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6)

// ❌ WRONG - .withOpacity() is DEPRECATED
Colors.black.withOpacity(0.08)  // DO NOT USE
theme.colorScheme.primary.withOpacity(0.1)  // DO NOT USE
```

**4. Card Shadows - Use Consistent Opacity:**
```dart
// ✅ CORRECT - Consistent subtle shadow for both themes
BoxShadow(
  color: Colors.black.withValues(alpha: 0.08),
  blurRadius: 8,
  offset: Offset(0, 2),
)

// ❌ WRONG - Different opacity per theme
BoxShadow(
  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),  // Don't do this
  blurRadius: 8,
  offset: Offset(0, 2),
)
```

**5. Error Widget Parameters:**
```dart
// ✅ CORRECT - Use single underscore for unused parameters
errorWidget: (_, __, _) => placeholder()

// ❌ WRONG - Multiple underscores
errorWidget: (_, __, ___) => placeholder()  // Lint warning
```

**6. Avoid Unused Variables:**
```dart
// ❌ WRONG - Declaring but not using
final isDark = Theme.of(context).brightness == Brightness.dark;
// ... isDark never used

// ✅ CORRECT - Only declare if you use it
// Don't declare isDark if you're using consistent shadows
```

**7. Testing:**
- Test all screens in light mode
- Test all screens in dark mode
- Verify text readability
- Check card visibility
- Ensure icons are visible
- Verify button colors
- Run diagnostics to ensure no warnings

**Theme Toggle:**
Users can toggle theme using the button in the AppBar:
```dart
context.read<ThemeCubit>().toggleTheme();
```

### Example Structure
Follow the structure of `lib/features/properties/` as a reference:
```
lib/features/[feature_name]/
├── domain/
│   ├── entities/
│   │   ├── [feature_name]_entity.dart
│   │   └── [feature_name]_response_entity.dart
│   ├── repositories/
│   │   └── [feature_name]_repository.dart
│   └── usecases/
│       └── get_[feature_name]_usecase.dart
├── data/
│   ├── models/
│   │   ├── [feature_name]_model.dart
│   │   └── [feature_name]_response_model.dart
│   ├── datasources/
│   │   └── [feature_name]_remote_data_source.dart
│   └── repositories/
│       └── [feature_name]_repository_impl.dart
├── presentation/
│   ├── cubit/
│   │   ├── [feature_name]_cubit.dart
│   │   └── [feature_name]_state.dart
│   ├── screens/
│   │   ├── [feature_name]_screen.dart
│   │   ├── [feature_name]_mobile_layout.dart
│   │   └── [feature_name]_tablet_layout.dart
│   └── widgets/
│       ├── [feature_name]_card.dart
│       └── [feature_name]_card_compact.dart (if needed)
└── README.md
```

Please create this feature following all the guidelines above.
```

---

## Example Usage

### Example 1: Offices Feature

```
I need you to create a new feature called "Offices" for a Flutter app following clean architecture.

### API Endpoint Information
- **Endpoint**: public/offices
- **Method**: GET
- **Query Parameters**: page, per_page
- **Response Structure**:
```json
{
  "success": true,
  "message": "تم جلب المكاتب بنجاح",
  "data": [
    {
      "id": 1,
      "name": "مكتب دار السلام العقاري",
      "slug": "mktb-dar-alslam-alaakary",
      "description": "مكتب عقاري متخصص في بيع وشراء العقارات",
      "phone": "+964 770 123 4567",
      "email": "info@daralsalam.iq",
      "address": "شارع الرئيسي، بغداد",
      "governorate_id": 1,
      "logo": "offices/office-1-logo.jpg",
      "properties_count": 45,
      "is_verified": true,
      "rating": 4.5,
      "created_at": "2026-01-15T10:00:00.000000Z",
      "governorate": {
        "id": 1,
        "name_ar": "بغداد"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 20,
    "total": 95
  }
}
```

[Continue with the rest of the template...]
```

### Example 2: Reviews Feature

```
I need you to create a new feature called "Reviews" for a Flutter app following clean architecture.

### API Endpoint Information
- **Endpoint**: public/reviews
- **Method**: GET
- **Query Parameters**: property_id (optional), page, per_page
- **Response Structure**:
```json
{
  "success": true,
  "message": "تم جلب التقييمات بنجاح",
  "data": [
    {
      "id": 1,
      "property_id": 91,
      "user_name": "أحمد محمد",
      "rating": 5,
      "comment": "عقار ممتاز والموقع رائع",
      "created_at": "2026-05-10T14:30:00.000000Z",
      "property": {
        "id": 91,
        "title": "أرض سكنية للبيع في حي المركز"
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "last_page": 3,
    "per_page": 20,
    "total": 58
  }
}
```

[Continue with the rest of the template...]
```

---

## Tips for Using This Prompt

1. **Replace Placeholders**: 
   - `[FEATURE_NAME]` → Actual feature name (e.g., "Offices", "Reviews")
   - `[feature_name]` → Lowercase with underscores (e.g., "offices", "reviews")
   - `[ENDPOINT_URL]` → Actual API endpoint
   - `[PASTE_API_RESPONSE_HERE]` → Actual API response JSON

2. **Customize Requirements**:
   - Add/remove sections based on feature needs
   - Specify if pagination is needed
   - Specify if home screen integration is needed
   - Add any special business logic requirements

3. **Provide Context**:
   - Mention if the feature is similar to an existing one
   - Specify any special UI requirements
   - Mention any dependencies or relationships with other features

4. **Be Specific**:
   - Provide complete API response examples
   - Specify exact field names and types
   - Mention any nullable fields
   - Specify any special formatting needs

5. **Reference Existing Code**:
   - Point to similar features as examples
   - Mention specific files to follow as patterns
   - Reference existing widgets to reuse

---

## Quick Start Template (Minimal)

For a quick feature generation, use this minimal version:

```
Create a new feature called "[FEATURE_NAME]" following the clean architecture pattern used in lib/features/properties/.

API Endpoint: [ENDPOINT]
Response: [PASTE_JSON_RESPONSE]

Requirements:
1. Complete domain, data, and presentation layers
2. Mobile and tablet layouts with responsive design
3. Pagination support (if applicable)
4. Home screen integration with horizontal scrolling (if applicable)
5. Follow the same structure as the properties feature

Please create all necessary files and ensure no diagnostic errors.
```

---

## Validation Checklist

After generating a feature, verify:

- [ ] All files created in correct directories
- [ ] Domain layer complete (entities, repository, use cases)
- [ ] Data layer complete (models, data sources, repository impl)
- [ ] Presentation layer complete (cubit, states, screens, widgets)
- [ ] Endpoint added to end_points.dart
- [ ] Factory method created in cubit
- [ ] Mobile and tablet layouts separated
- [ ] Pagination implemented (if needed)
- [ ] Error handling implemented
- [ ] Loading states implemented
- [ ] Empty states implemented
- [ ] Pull-to-refresh implemented
- [ ] **No diagnostic errors or warnings**
- [ ] Proper null safety
- [ ] Arabic text used in UI
- [ ] Images cached properly (if applicable)
- [ ] Numbers formatted correctly
- [ ] README.md created
- [ ] **No deprecated APIs used (especially .withOpacity)**
- [ ] **Network info check includes ?? false**
- [ ] **Shadows use consistent opacity (0.08)**
- [ ] **No unused variables declared**
- [ ] **Error widget uses single underscores (_, __, _)**

### Code Review Checklist

Before considering the feature complete, verify:

**API Usage:**
- [ ] No `.withOpacity()` - use `.withValues(alpha: ...)` instead
- [ ] No other deprecated Flutter APIs
- [ ] All imports are correct

**Null Safety:**
- [ ] Network info check: `if (!(await networkInfo.isConnected ?? false))`
- [ ] All nullable fields handled properly
- [ ] No null-related warnings

**Code Style:**
- [ ] No unused variables
- [ ] Error widget parameters: `(_, __, _)` not `(_, __, ___)`
- [ ] Consistent naming conventions

**Theme Support:**
- [ ] Uses `Theme.of(context)` for colors
- [ ] Shadows use `.withValues(alpha: 0.08)`
- [ ] No hardcoded colors (Colors.white, Colors.black)
- [ ] Tested in both light and dark modes

**Diagnostics:**
- [ ] Run diagnostics on all files
- [ ] 0 errors
- [ ] 0 warnings
- [ ] 0 info messages

---

## Common Mistakes to Avoid

### ❌ CRITICAL: Do NOT Use Deprecated APIs

**1. Opacity - Use .withValues() NOT .withOpacity()**
```dart
// ❌ WRONG - DEPRECATED
Colors.black.withOpacity(0.08)
color.withOpacity(0.5)

// ✅ CORRECT
Colors.black.withValues(alpha: 0.08)
color.withValues(alpha: 0.5)
```

**2. Network Info Null Check**
```dart
// ❌ WRONG - Nullable bool in condition
if (!await networkInfo.isConnected) {

// ✅ CORRECT - Handle null with coalescing
if (!(await networkInfo.isConnected ?? false)) {
```

**3. Error Widget Parameters**
```dart
// ❌ WRONG - Multiple underscores
errorWidget: (_, __, ___) => widget

// ✅ CORRECT - Single underscore
errorWidget: (_, __, _) => widget
```

**4. Unused Variables**
```dart
// ❌ WRONG - Declared but never used
final isDark = Theme.of(context).brightness == Brightness.dark;
// ... code that doesn't use isDark

// ✅ CORRECT - Don't declare if not needed
// Just remove the variable
```

**5. Shadow Consistency**
```dart
// ❌ WRONG - Different shadows per theme
BoxShadow(
  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
)

// ✅ CORRECT - Consistent subtle shadow
BoxShadow(
  color: Colors.black.withValues(alpha: 0.08),
)
```

### ✅ Best Practices Checklist

Before submitting code, verify:
- [ ] No `.withOpacity()` usage (use `.withValues(alpha: ...)` instead)
- [ ] Network info check includes `?? false`
- [ ] No multiple underscores in unused parameters
- [ ] No unused variable declarations
- [ ] Consistent shadow opacity (0.08 for all themes)
- [ ] All diagnostics pass (0 errors, 0 warnings)
- [ ] Theme tested in both light and dark modes

## Notes

- This prompt template is based on the architecture used in the dalil_alaqar project
- It follows clean architecture principles with domain, data, and presentation layers
- It uses BLoC pattern with Cubit for state management
- It includes responsive design for mobile and tablet
- It follows the same patterns as the properties and advertisements features
- **IMPORTANT**: Always use modern Flutter APIs - avoid deprecated methods
